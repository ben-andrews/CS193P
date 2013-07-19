//
//  Photo+Flickr.m
//  SPoT_CoreData
//
//  Created by Ben Andrews on 15/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Tag+Create.h"

@implementation Photo (Flickr)

#define TAGS_TO_SKIP @[@"cs193pspot", @"portrait", @"landscape"]
#define PHOTO_ENTITY @"Photo"
#define TITLE_ATTRIBUTE @"title"

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    // Build a fetch request to see if we can find this Flickr photo in the database.
    // The "photoID" attribute in Photo is Flickr's "id" which is guaranteed by Flickr to be unique.
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:PHOTO_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:TITLE_ATTRIBUTE ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"photoID = %@", [photoDictionary[FLICKR_PHOTO_ID] description]];
    
    // Execute the fetch
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // Check what happened in the fetch
    
    if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
        photo = [NSEntityDescription insertNewObjectForEntityForName:PHOTO_ENTITY inManagedObjectContext:context];
        photo.photoID = [photoDictionary[FLICKR_PHOTO_ID] description];
        photo.title = [photoDictionary[FLICKR_PHOTO_TITLE] description];
        photo.subtitle = [[photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
        FlickrPhotoFormat imageFormat = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? FlickrPhotoFormatOriginal : FlickrPhotoFormatLarge;
        photo.photoURL = [[FlickrFetcher urlForPhoto:photoDictionary format:imageFormat] absoluteString];
        photo.thumbnailURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
        
        NSMutableArray *tags = [[[photoDictionary[FLICKR_TAGS] description] componentsSeparatedByString:@" "] mutableCopy];
        [tags removeObjectsInArray:TAGS_TO_SKIP];
        
        for (NSString *tagString in tags) {
            Tag *tag = [Tag tagWithName:tagString forPhoto:photo inManagedObjectContext:context];
            NSMutableSet *existingTags = [photo.tags mutableCopy];
            [existingTags addObject:tag];
            photo.tags = existingTags;
        }
    } else { // found the Photo, just return it from the list of matches (which there will only be one of)
        photo = [matches lastObject];
    }
    
    return photo;
}

@end

//
//  Tag+Create.m
//  SPoT_CoreData
//
//  Created by Ben Andrews on 15/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

#define TAG_ENTITY @"Tag"
#define NAME_ATTRIBUTE @"name"

+ (Tag *)tagWithName:(NSString *)tagName forPhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tag *tag = nil;
    
    // Same process as Photo+Flickr
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TAG_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NAME_ATTRIBUTE ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", tagName];
    
    // Execute the fetch
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // Check what happened in the fetch
    
    if (![matches count]) {
        tag = [NSEntityDescription insertNewObjectForEntityForName:TAG_ENTITY inManagedObjectContext:context];
        tag.name = tagName;
        tag.photos = [NSSet setWithObject:photo];
    } else {
        tag = [matches lastObject];
        NSMutableSet *photos = [tag.photos mutableCopy];
        [photos addObject:photo];
        tag.photos = photos;
    }
    return tag;
}

@end

//
//  PhotosCDTVC.m
//  SPoT_CoreData
//
//  Created by Ben Andrews on 16/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "PhotosCDTVC.h"
#import "Photo.h"
#import "Photo+MKAnnotation.h"
#import "ImageCacheManager.h"
#import "FlickrFetcher.h"
#import "SPoTAppDelegate.h"
#import "SharedManagedDocument.h"

@interface PhotosCDTVC ()

@end

@implementation PhotosCDTVC

#define PHOTO_ENTITY @"Photo"
#define IMAGE_SEGUE @"Show Image"

- (void)setupFetchedResultsController {} // abstract

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        [self useDocument];
    } else {
        [self setupFetchedResultsController];
    }
}

- (void)useDocument
{
    SharedManagedDocument *sharedDocument = [SharedManagedDocument sharedDocument];
    UIManagedDocument *document = sharedDocument.document;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[document fileURL] path]]) {
        [document saveToURL:[document fileURL]
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
                  [self setupFetchedResultsController];
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
                [self setupFetchedResultsController];
            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
        [self setupFetchedResultsController];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PHOTO_ENTITY];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    cell.imageView.image = [photo thumbnailImage];
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        // Record that photo was viewed
        photo.lastViewed = [NSDate date];
        if (indexPath) {
            if ([segue.identifier isEqualToString:IMAGE_SEGUE]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    NSURL *url = [NSURL URLWithString:[photo photoURL]];
                    NSString *photoID = [photo photoID];
                    if (![ImageCacheManager imageInCache:photoID]) {
                        [ImageCacheManager cacheImageFromUrl:url withFilename:photoID];
                    } else {
                        url = [ImageCacheManager urlForImage:photoID];
                    }
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[photo title]];
                }
            }
        }
    }
}

@end

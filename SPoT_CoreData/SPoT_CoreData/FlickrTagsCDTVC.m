//
//  FlickrTagsCDTVC.m
//  SPoT_CoreData
//
//  Created by Ben Andrews on 15/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "FlickrTagsCDTVC.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "SharedManagedDocument.h"

@implementation FlickrTagsCDTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useDocument];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
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
                  [self refresh];
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
    }
}

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        // put the photos in Core Data
        [self.managedObjectContext performBlock:^{
            for (NSDictionary *photo in photos) {
                [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

@end

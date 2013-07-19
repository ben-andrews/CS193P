//
//  PhotoHistoryCDTVC.m
//  SPoT_CoreData
//
//  Created by Ben Andrews on 16/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "PhotoHistoryCDTVC.h"

@interface PhotoHistoryCDTVC ()

@end

@implementation PhotoHistoryCDTVC

#define PHOTO_ENTITY @"Photo"
#define LAST_VIEWED_ATTRIBUTE @"lastViewed"

- (void)setupFetchedResultsController
{
    if (self.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:PHOTO_ENTITY];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:LAST_VIEWED_ATTRIBUTE ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"lastViewed != nil"];
        request.fetchLimit = 10;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

@end

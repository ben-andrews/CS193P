//
//  PhotosByTagCDTVC.m
//  SPoT_CoreData
//
//  Created by Ben Andrews on 15/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "PhotosByTagCDTVC.h"
#import "FlickrFetcher.h"

@interface PhotosByTagCDTVC ()

@end

@implementation PhotosByTagCDTVC

#define PHOTO_ENTITY @"Photo"
#define TITLE_ATTRIBUTE @"title"

#pragma mark - Properties

- (void)setTag:(Tag *)tag
{
    _tag = tag;
    self.title = [tag.name capitalizedString];
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:PHOTO_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:TITLE_ATTRIBUTE ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY tags == %@", self.tag];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

@end


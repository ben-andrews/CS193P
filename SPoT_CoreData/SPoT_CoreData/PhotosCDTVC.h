//
//  PhotosCDTVC.h
//  SPoT_CoreData
//
//  Created by Ben Andrews on 16/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface PhotosCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)setupFetchedResultsController; // abstract

@end

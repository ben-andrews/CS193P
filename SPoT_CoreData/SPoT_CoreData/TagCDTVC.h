//
//  TagCDTVC.h
//  SPoT_CoreData
//
//  Created by Ben Andrews on 15/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//
// Can do "setTag:" segue and will call said method in destination VC.

#import "CoreDataTableViewController.h"

@interface TagCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

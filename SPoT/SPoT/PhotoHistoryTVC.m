//
//  PhotoHistoryTVC.m
//  SPoT
//
//  Created by Ben Andrews on 23/06/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "PhotoHistoryTVC.h"

@interface PhotoHistoryTVC ()
@end

@implementation PhotoHistoryTVC

#define ALL_PHOTOS_KEY @"PhotoHistory_All"
#define DATE_KEY @"Date_Selected"

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *mutablePhotoHistoryFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_PHOTOS_KEY] mutableCopy];
    if (mutablePhotoHistoryFromUserDefaults) {
        self.photos = [mutablePhotoHistoryFromUserDefaults allValues];
        NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:DATE_KEY ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];
        self.photos = [self.photos sortedArrayUsingDescriptors:sortDescriptors];
    }
}

@end

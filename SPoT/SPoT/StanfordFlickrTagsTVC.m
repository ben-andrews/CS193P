//
//  StanfordFlickrTagsTVC.m
//  SPoT
//
//  Created by Ben Andrews on 23/06/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "StanfordFlickrTagsTVC.h"
#import "FlickrFetcher.h"

@implementation StanfordFlickrTagsTVC

#define TAGS_TO_SKIP @[@"cs193pspot", @"portrait", @"landscape"]

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *photos = [FlickrFetcher stanfordPhotos];
    
    NSMutableDictionary *tags = [[NSMutableDictionary alloc] init];
    for (NSDictionary *photo in photos) {
        NSArray *allTags = [[photo objectForKey:@"tags"] componentsSeparatedByString:@" "];
        for (NSString *tag in allTags) {
            if (![TAGS_TO_SKIP containsObject:tag]) {
                if ([tags objectForKey:tag]) {
                    [[tags objectForKey:tag] addObject:photo];
                } else {
                    [tags setObject:[NSMutableArray arrayWithObject:photo] forKey:tag];
                }
            }
        }
    }
    self.tags = tags;
}

@end

//
//  Photo+MKAnnotation.m
//  SPoT_CoreData
//
//  Created by Ben Andrews on 24/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "Photo+MKAnnotation.h"
#import "SPoTAppDelegate.h"

@implementation Photo (MKAnnotation)

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

- (UIImage *)thumbnailImage
{
    if (!self.thumbnail) {
        SPoTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        dispatch_queue_t thumbnailFetchQ = dispatch_queue_create("thumbnail fetcher", NULL);
        dispatch_async(thumbnailFetchQ, ^{
            [delegate incrementNetworkActivity];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.thumbnailURLString]];
            [delegate decrementNetworkActivity];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.thumbnail = imageData;
            });
        });
    }
    return [UIImage imageWithData:self.thumbnail];
}

@end

//
//  Photo+MKAnnotation.h
//  SPoT_CoreData
//
//  Created by Ben Andrews on 24/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "Photo.h"
#import <MapKit/MapKit.h>

@interface Photo (MKAnnotation) <MKAnnotation>

- (UIImage *)thumbnailImage;

@end

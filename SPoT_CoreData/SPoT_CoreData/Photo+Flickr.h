//
//  Photo+Flickr.h
//  SPoT_CoreData
//
//  Created by Ben Andrews on 15/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

@end

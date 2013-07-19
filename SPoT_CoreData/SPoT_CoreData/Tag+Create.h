//
//  Tag+Create.h
//  SPoT_CoreData
//
//  Created by Ben Andrews on 15/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "Tag.h"
#import "Photo+Flickr.h"

@interface Tag (Create)

+ (Tag *)tagWithName:(NSString *)name forPhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context;

@end

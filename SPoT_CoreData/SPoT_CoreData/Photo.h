//
//  Photo.h
//  SPoT_CoreData
//
//  Created by Ben Andrews on 16/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * photoID;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * lastViewed;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end

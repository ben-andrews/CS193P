//
//  ImageCacheManager.h
//  SPoT
//
//  Created by Ben Andrews on 03/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCacheManager : NSObject

+ (BOOL)imageInCache:(NSString *)filename;
+ (void)cacheImageFromUrl:(NSURL *)url withFilename:(NSString *)filename;
+ (NSURL *)urlForImage:(NSString *)filename;

@end

//
//  ImageCacheManager.m
//  SPoT
//
//  Created by Ben Andrews on 03/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "ImageCacheManager.h"

@implementation ImageCacheManager

#define IMAGE_CACHE @"cachedImages/"
#define IPAD_CACHE_MAX_SIZE 6000000 // (bytes) = 4 photos
#define IPHONE_CACHE_MAX_SIZE 2000000 // 4 photos

+ (NSURL *)urlForImage:(NSString *)filename
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *cacheUrl = [fileManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    cacheUrl = [cacheUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", IMAGE_CACHE]];
    if (![fileManager fileExistsAtPath:[cacheUrl path]]) {
        [fileManager createDirectoryAtURL:cacheUrl withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSURL *imageUrl = [cacheUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",filename]];
    return imageUrl;
}

+ (BOOL)imageInCache:(NSString *)filename
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *imageUrl = [self urlForImage:filename];
    return ([fileManager fileExistsAtPath:[imageUrl path]]);
}

+ (void)cacheImageFromUrl:(NSURL *)url withFilename:(NSString *)filename
{
    NSURL *localUrl = [self urlForImage:filename];
    if (![self imageInCache:filename]) {
        
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
            [self checkSizeOfCacheWithNewData:[imageData length]];
            if (imageData) [imageData writeToURL:localUrl atomically:YES];
        });
    } else {
        [localUrl setResourceValue:[NSDate date] forKey:NSURLContentAccessDateKey error:nil];
    }
}

+ (void)checkSizeOfCacheWithNewData:(NSUInteger)newImageSize
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *cacheUrl = [fileManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    cacheUrl = [cacheUrl URLByAppendingPathComponent:IMAGE_CACHE];
    NSArray *urls = [fileManager contentsOfDirectoryAtURL:cacheUrl includingPropertiesForKeys:@[NSURLContentAccessDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    NSUInteger totalSize = 0;
    for (NSURL *url in urls) {
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:[url path] error:nil];
        totalSize += [attributes[NSFileSize] unsignedIntegerValue];        
    }
    NSUInteger maxSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? IPAD_CACHE_MAX_SIZE : IPHONE_CACHE_MAX_SIZE;
    if (totalSize + newImageSize > maxSize) [self removeOldestImageFromCache:urls];
    
}

+ (void)removeOldestImageFromCache:(NSArray *)urls
{
    NSArray *sortedPhotos = [urls sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDictionary *urlA = [(NSURL*)a resourceValuesForKeys:@[NSURLContentAccessDateKey] error:nil];
        NSDictionary *urlB = [(NSURL*)b resourceValuesForKeys:@[NSURLContentAccessDateKey] error:nil];
        NSDate *first = urlA[NSURLContentAccessDateKey];
        NSDate *second = urlB[NSURLContentAccessDateKey];
        return [first compare:second]; // oldest to newest
    }];
    
    NSURL *oldestPhoto = sortedPhotos[0];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtURL:oldestPhoto error:nil];
}

@end

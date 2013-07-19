//
//  SharedManagedDocument.m
//  SPoT_CoreData
//
//  Created by Ben Andrews on 18/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "SharedManagedDocument.h"

@implementation SharedManagedDocument

#define DOCUMENT_NAME @"Photos Document"

static SharedManagedDocument *sharedDocument = nil;

+ (SharedManagedDocument *)sharedDocument
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDocument = [[self alloc] init];
    });
    return sharedDocument;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:DOCUMENT_NAME];
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    return self;
}


@end

//
//  SharedManagedDocument.h
//  SPoT_CoreData
//
//  Created by Ben Andrews on 18/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//
// Singleton class

#import <Foundation/Foundation.h>

@interface SharedManagedDocument : NSObject

@property (strong, nonatomic)UIManagedDocument *document;

+ (SharedManagedDocument *)sharedDocument;

@end

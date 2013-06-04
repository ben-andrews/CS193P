//
//  SetCard.h
//  Matchismo
//
//  Created by Ben Andrews on 30/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSString *symbol;
@property (nonatomic) NSString *color;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shading;

+ (NSArray *)symbols;
+ (NSArray *)colors;
+ (NSArray *)numbers;
+ (NSArray *)shadings;

@end

//
//  PlayingCard.h
//  Matchismo
//
//  Created by Ben Andrews on 24/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end

//
//  SetCard.m
//  Matchismo
//
//  Created by Ben Andrews on 30/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

#define MATCH_POINTS 4

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    NSMutableArray *cards = [NSMutableArray arrayWithArray:otherCards];
    [cards addObject:self];
    
    NSMutableSet *symbols = [[NSMutableSet alloc] init];
    NSMutableSet *colors = [[NSMutableSet alloc] init];
    NSMutableSet *numbers = [[NSMutableSet alloc] init];
    NSMutableSet *shadings = [[NSMutableSet alloc] init];
    
    for (SetCard *otherCard in cards) {
        [symbols addObject:@(otherCard.symbol)];
        [colors addObject:@(otherCard.color)];
        [shadings addObject:@(otherCard.shading)];
        [numbers addObject:@(otherCard.number)];
    }
    
    if (((symbols.count == 1) || (symbols.count == 3)) &&
        ((colors.count == 1) || (colors.count == 3)) &&
        ((numbers.count == 1) || (numbers.count == 3)) &&
        ((shadings.count == 1) || (shadings.count == 3))) score = MATCH_POINTS;
    
    return score;
}

+ (NSArray *)symbols
{
    return @[@1, @2, @3];
}

+ (NSArray *)colors
{
    return @[@1, @2, @3];
}

+ (NSArray *)numbers
{
    return @[@1, @2, @3];
}

+ (NSArray *)shadings
{
    return @[@1, @2, @3];
}

@end

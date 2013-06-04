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
    
    NSMutableSet *numbers = [[NSMutableSet alloc] init];
    NSMutableSet *symbols = [[NSMutableSet alloc] init];
    NSMutableSet *shadings = [[NSMutableSet alloc] init];
    NSMutableSet *colors = [[NSMutableSet alloc] init];
    
    for (SetCard *otherCard in cards) {
        [numbers addObject:@(otherCard.number)];
        [symbols addObject:otherCard.symbol];
        [shadings addObject:@(otherCard.shading)];
        [colors addObject:otherCard.color];
    }
    
    if (((numbers.count == 1) || (numbers.count == 3)) &&
        ((symbols.count == 1) || (symbols.count == 3)) &&
        ((shadings.count == 1) || (shadings.count == 3)) &&
        ((colors.count == 1) || (colors.count == 3))) score = MATCH_POINTS;
    
    return score;
}

+ (NSArray *)symbols
{
    return @[@"▲", @"●", @"■"];
}

+ (NSArray *)colors
{
    return @[@"Red", @"Green", @"Blue"];
}

+ (NSArray *)numbers
{
    return @[@1, @2, @3];
}

+ (NSArray *)shadings
{
    return @[@0, @1, @2];
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@ %@ %d %d", self.symbol, self.color, self.number, self.shading];
}

@end

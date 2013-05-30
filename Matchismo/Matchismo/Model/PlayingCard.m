//
//  PlayingCard.m
//  Matchismo
//
//  Created by Ben Andrews on 24/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

#define SUIT_MATCH 1
#define RANK_MATCH 4

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    NSMutableArray *cards = [NSMutableArray arrayWithArray:otherCards];
    [cards addObject:self];
    
    NSMutableSet *suits = [[NSMutableSet alloc] init];
    NSMutableSet *ranks = [[NSMutableSet alloc] init];
    
    for (PlayingCard *otherCard in cards) {
        [suits addObject:otherCard.suit];
        [ranks addObject:[NSNumber numberWithInt:otherCard.rank]];
    }
    
    if (suits.count == 1) {
        score = (cards.count == 2) ? SUIT_MATCH : SUIT_MATCH * cards.count;
    } else if (ranks.count == 1) {
        score = (cards.count == 2) ? RANK_MATCH : RANK_MATCH * cards.count;
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♥",@"♦",@"♠",@"♣"];
    return validSuits;
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count-1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) _rank = rank;
}

@end

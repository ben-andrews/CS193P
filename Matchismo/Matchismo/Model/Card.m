//
//  Card.m
//  Matchismo
//
//  Created by Ben Andrews on 24/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

@end

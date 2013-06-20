//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Ben Andrews on 30/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    if (self) {
        for (NSUInteger symbol = 1; symbol <= [SetCard symbols].count; symbol++) {
            for (NSUInteger color = 1; color <= [SetCard colors].count; color++) {
                for (NSUInteger number = 1; number <= [SetCard numbers].count; number++) {
                    for (NSUInteger shading = 1; shading <= [SetCard shadings].count; shading++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.color = color;
                        card.number = number;
                        card.shading = shading;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end

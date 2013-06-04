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
        for (NSString *symbol in [SetCard symbols]) {
            for (NSString *color in [SetCard colors]) {
                for (NSUInteger number = 1; number <= [SetCard numbers].count; number++) {
                    for (NSUInteger shading = 0; shading < [SetCard shadings].count; shading++) {
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

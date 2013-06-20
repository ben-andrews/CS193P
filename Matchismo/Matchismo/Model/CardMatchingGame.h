//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Ben Andrews on 25/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// Designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck
       withCardsToMatch:(NSUInteger)cardsToMatch;

- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (BOOL)addThreeCards;

@property (nonatomic, readonly) int score;
@property (nonatomic) NSMutableArray *cardsFlipped;
@property (nonatomic) NSUInteger numCardsInPlay;
@property (nonatomic, readonly) int scoreChange;
@property (nonatomic) int numCardsToMatch;

@end

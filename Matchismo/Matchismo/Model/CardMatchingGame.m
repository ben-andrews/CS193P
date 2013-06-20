//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Ben Andrews on 25/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) int scoreChange;
@property (nonatomic) Deck *deck;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)cardsFlipped
{
    if (!_cardsFlipped) _cardsFlipped = [[NSMutableArray alloc] init];
    return _cardsFlipped;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck withCardsToMatch:(NSUInteger)cardsToMatch
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        self.numCardsToMatch = cardsToMatch;
        self.numCardsInPlay = count;
        self.deck = deck;
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (BOOL)addThreeCards
{
    for (int i = 0; i < 3; i++) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
        } else {
            return NO;
        }
    }
    self.numCardsInPlay += 3;
    return YES;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
#define SET_GAME_NUM_CARDS 3

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    // Post-match
    if ((self.cardsFlipped.count == self.numCardsToMatch) && (self.scoreChange > 0)) {
        [self.cardsFlipped removeAllObjects];
    }
    
    // Post-mismatch
    if ((self.cardsFlipped.count == self.numCardsToMatch) && (self.scoreChange < 0)) {
        NSRange range = NSMakeRange(0, self.cardsFlipped.count-1);
        [self.cardsFlipped removeObjectsInRange:range];
    }

    // Flip down
    if (card.isFaceUp) [self.cardsFlipped removeObject:card];
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            if (self.cardsFlipped.count == self.numCardsToMatch-1) {
                int matchScore = [card match:self.cardsFlipped];
                if (matchScore) {
                    for (Card *flippedCard in self.cardsFlipped) {
                        flippedCard.unplayable = YES;
                        if (self.numCardsToMatch == SET_GAME_NUM_CARDS) [self.cards removeObject:flippedCard];
                    }
                    card.unplayable = YES;
                    if (self.numCardsToMatch == SET_GAME_NUM_CARDS) [self.cards removeObject:card];
                    self.numCardsInPlay -= self.numCardsToMatch;
                    self.score += matchScore * MATCH_BONUS;
                    self.scoreChange = matchScore * MATCH_BONUS;
                } else {
                    for (Card *flippedCard in self.cardsFlipped) {
                        flippedCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                    self.scoreChange = -MISMATCH_PENALTY;
                }
            }
            self.score -= FLIP_COST;
        }
        if (!card.isFaceUp) [self.cardsFlipped addObject:card];
        card.faceUp = !card.isFaceUp;
    }
}

@end

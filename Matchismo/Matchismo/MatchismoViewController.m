//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Ben Andrews on 31/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCardDeck.h"

@interface MatchismoViewController()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@end

@implementation MatchismoViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

#define NUM_CARDS 16;

- (NSUInteger)cardCount
{
    return NUM_CARDS;
}

#define CARDS_TO_MATCH 2;

- (NSUInteger)cardsToMatch
{
    return CARDS_TO_MATCH;
}

- (void)updateUI
{
    [super updateUI];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
}

@end

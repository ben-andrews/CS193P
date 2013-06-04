//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Ben Andrews on 30/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"

@interface SetGameViewController()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@end

@implementation SetGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

#define NUM_CARDS 24;

- (NSUInteger)cardCount
{
    return NUM_CARDS;
}

#define CARDS_TO_MATCH 3;

- (NSUInteger)cardsToMatch
{
    return CARDS_TO_MATCH;
}

- (UIImage *)cardBack
{
    return nil;
}

#define SHADING_ALPHA 0.3

- (UIColor *)getColor:(NSString *)clr withShading:(NSUInteger)shading
{
    UIColor *color = [UIColor whiteColor];
    if ([clr isEqualToString:@"Red"]) color = [UIColor redColor];
    if ([clr isEqualToString:@"Green"]) color = [UIColor greenColor];
    if ([clr isEqualToString:@"Blue"]) color = [UIColor blueColor];
        
    if (shading == 0) color = [color colorWithAlphaComponent:0];
    if (shading == 1) color = [color colorWithAlphaComponent:SHADING_ALPHA];
    if (shading == 2) color = [color colorWithAlphaComponent:1];

    return color;
}

#define STROKE_WIDTH @-5

- (NSAttributedString *)getAttributedStringForCard:(SetCard *)card
{
    NSString *symbol = [[NSString alloc] init];
    for (int i = 0; i < card.number; i++) {
        symbol = [NSString stringWithFormat:@"%@%@", symbol, card.symbol];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:symbol];
    NSDictionary *attributes = @{ NSStrokeColorAttributeName : [self getColor:card.color withShading:2],
                                  NSStrokeWidthAttributeName : STROKE_WIDTH,
                                  NSForegroundColorAttributeName : [self getColor:card.color withShading:card.shading]};
    
    NSRange range = NSMakeRange(0, attString.length);
    [attString setAttributes:attributes range:range];
    
    return attString;
}

- (NSAttributedString *)getAttributedStringForCards:(NSArray *)cards
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < cards.count; i++) {
        [attString appendAttributedString:cards[i]];
        if (i < cards.count-1) [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@" & "]];
    }
    return attString;
}

- (void)updateUI
{
    [super updateUI];
    for (UIButton *cardButton in self.cardButtons) {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        NSAttributedString *attString = [self getAttributedStringForCard:card];
        [cardButton setAttributedTitle:attString forState:UIControlStateNormal];
        
        if (card.isFaceUp) {
            [cardButton setBackgroundColor:[UIColor lightGrayColor]];
        } else {
            [cardButton setBackgroundColor:[UIColor whiteColor]];
        }
        
        cardButton.hidden = card.isUnplayable ? YES : NO;
    }
}

#define WELCOME_MSG @"Welcome to Set"

- (void)updateFlipResult
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (SetCard *flippedCard in self.game.cardsFlipped) {
        [cards addObject:[self getAttributedStringForCard:flippedCard]];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    
    if ((cards.count) && (cards.count < self.game.numCardsToMatch)) {
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped up "]];
        [attString appendAttributedString:[self getAttributedStringForCards:cards]];
        self.flipResult.attributedText = attString;
    } else if (cards.count == self.game.numCardsToMatch) {
        if (self.game.scoreChange > 0) {
            [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"Matched "]];
            [attString appendAttributedString:[self getAttributedStringForCards:cards]];
            [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points", self.game.scoreChange]]];
            self.flipResult.attributedText = attString;
        } else {
            [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithAttributedString:[self getAttributedStringForCards:cards]]];
            [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" don’t match! %d point penalty", self.game.scoreChange]]];
        }
    }
    self.flipResult.attributedText = attString;
}

@end

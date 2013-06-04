//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ben Andrews on 24/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@property (nonatomic) UIImage *cardBack;
@end

@implementation CardGameViewController

- (Deck *)createDeck
{
    return nil;
}

- (void)updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardCount
                                                          usingDeck:[self createDeck]
                                                   withCardsToMatch:self.cardsToMatch];
    return _game;
}

- (UIImage *)cardBack
{
    return [UIImage imageNamed:@"cardback.png"];
}

#define IMAGE_INSET 5

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;

    UIImage *cardBackImage = self.cardBack;
    UIImage *noImage = [[UIImage alloc] init];
    for (UIButton *button in cardButtons) {
        [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [button setImage:cardBackImage forState:UIControlStateNormal];
        [button setImage:noImage forState:UIControlStateSelected];
        [button setImage:noImage forState:UIControlStateSelected|UIControlStateDisabled];
    }
    
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender
{    
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateFlipResult];
    self.flipCount++;
    [self updateUI];
}

- (void)updateFlipResult
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (Card *flippedCard in self.game.cardsFlipped) {
        [cards addObject:flippedCard.contents];
    }
    
    if ((cards.count) && (cards.count < self.game.numCardsToMatch)) {
        self.flipResult.text = [NSString stringWithFormat:@"Flipped up %@", [cards componentsJoinedByString:@" "]];
    } else if (cards.count == self.game.numCardsToMatch) {
        if (self.game.scoreChange > 0) {
            self.flipResult.text = [NSString stringWithFormat:@"Matched %@ for %d points", [cards componentsJoinedByString:@" & "], self.game.scoreChange];
        } else {
            self.flipResult.text = [NSString stringWithFormat:@"%@ don’t match! %d point penalty", [cards componentsJoinedByString:@" & "], self.game.scoreChange];
        }
    }
}

- (IBAction)deal
{
    self.game = nil;
    [self setFlipCount:0];
    self.flipResult.text = @"";
    [self updateUI];
}

@end

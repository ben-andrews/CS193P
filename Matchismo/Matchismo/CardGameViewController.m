//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ben Andrews on 24/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegControl;

@end


@implementation CardGameViewController

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

#define IMAGE_INSET 5

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    UIImage *noImage = [[UIImage alloc] init];
    for (UIButton *button in cardButtons) {
        [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [button setImage:cardBackImage forState:UIControlStateNormal];
        [button setImage:noImage forState:UIControlStateSelected];
        [button setImage:noImage forState:UIControlStateSelected|UIControlStateDisabled];
    }
    
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (IBAction)flipCard:(UIButton *)sender
{
    if (self.gameModeSegControl.enabled) self.gameModeSegControl.enabled = NO;
    
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateFlipResult];
    self.flipCount++;
    [self updateUI];
}

#define WELCOME_MSG @"Welcome to Matchismo"

- (void)updateFlipResult
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (Card *flippedCard in self.game.cardsFlipped) {
        [cards addObject:flippedCard.contents];
    }
    
    if (!cards) {
        self.flipResult.text = WELCOME_MSG;
    } else if ((cards.count) && (cards.count < self.game.numCardsToMatch)) {
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
    self.flipResult.text = WELCOME_MSG;
    self.gameModeSegControl.enabled = YES;
    [self changeGameMode];
    [self updateUI];
}

- (IBAction)changeGameMode
{
    self.game.numCardsToMatch = self.gameModeSegControl.selectedSegmentIndex+2;
}

@end

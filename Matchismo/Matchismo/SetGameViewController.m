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
#import "SetCardView.h"
#import "SetCardCollectionViewCell.h"
#import "FlipResultView.h"

@interface SetGameViewController()
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet FlipResultView *flipResultView;

@end

@implementation SetGameViewController

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animated:(BOOL)animated
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.number = setCard.number;
            setCardView.shading = setCard.shading;
            setCardView.symbol = setCard.symbol;
            
            setCardView.strokeColor = [self getColor:setCard.color withShading:[SetCard shadings].count];
            setCardView.fillColor = [self getColor:setCard.color withShading:setCard.shading];
            
            setCardView.selected = setCard.isFaceUp;
            setCardView.backgroundColor = (setCard.isFaceUp) ? [UIColor lightGrayColor] : [UIColor whiteColor];
            setCardView.alpha = setCard.isUnplayable ? 0.1 : 1.0; // to be removed
        }
    }
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

#define NUM_CARDS 12;

- (NSUInteger)startingCardCount
{
    return NUM_CARDS;
}

#define NUM_CARDS_TO_MATCH 3;

- (NSUInteger)numCardsToMatch
{
    return NUM_CARDS_TO_MATCH;
}

- (NSString *)reuseIdentifier
{
    return @"SetCard";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.game.numCardsInPlay;
}

#define SHADING_ALPHA 0.3
#define COLOR_1 [UIColor redColor]
#define COLOR_2 [UIColor greenColor]
#define COLOR_3 [UIColor purpleColor]

- (UIColor *)getColor:(NSUInteger)clr withShading:(NSUInteger)shading
{
    UIColor *color = [UIColor whiteColor];
    if (clr == 1) color = COLOR_1;
    if (clr == 2) color = COLOR_2;
    if (clr == 3) color = COLOR_3;
        
    if (shading == 1) color = [color colorWithAlphaComponent:0];
    if (shading == 2) color = [color colorWithAlphaComponent:SHADING_ALPHA];
    if (shading == 3) color = [color colorWithAlphaComponent:1];

    return color;
}

- (void)updateUI
{
    [self.cardCollectionView reloadData];
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animated:YES];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self updateFlipResult];
}

#define SPACING 3
#define CARD_WIDTH 40
#define CARD_HEIGHT 50
#define FLIPPED_UP_LABEL_WIDTH 80
#define FLIPPED_UP_LABEL_HEIGHT 25
#define FLIPPED_UP_LABEL_Y_FACTOR 0.25

- (void)updateFlipResult
{
    [self removeSubviewsFromView:self.flipResultView];
    
    for (int i = 0; i < self.game.cardsFlipped.count; i++) {
        NSUInteger x = i * CARD_WIDTH;
        if (i != 0) x += SPACING;
        SetCardView *cardView = [[SetCardView alloc] initWithFrame:CGRectMake(x, 0, CARD_WIDTH, CARD_HEIGHT)];
        SetCard *card = self.game.cardsFlipped[i];
        cardView.symbol = card.symbol;
        cardView.number = card.number;
        cardView.strokeColor = [self getColor:card.color withShading:[SetCard shadings].count];
        cardView.fillColor = [self getColor:card.color withShading:card.shading];
        
        cardView.opaque = NO;
        [self.flipResultView addSubview:cardView];
    }
    
    if (self.game.cardsFlipped.count) {
        UILabel *cardsFlippedLabel = [[UILabel alloc] initWithFrame:CGRectMake((CARD_WIDTH + SPACING) * self.game.cardsFlipped.count, CARD_HEIGHT * FLIPPED_UP_LABEL_Y_FACTOR, self.view.bounds.size.width - (CARD_WIDTH + SPACING) * self.game.cardsFlipped.count, FLIPPED_UP_LABEL_HEIGHT)];
        cardsFlippedLabel.text = [self getCardsFlippedMessageText];
        [cardsFlippedLabel setAdjustsFontSizeToFitWidth:YES];
        [self.flipResultView addSubview:cardsFlippedLabel];
    }
}

@end

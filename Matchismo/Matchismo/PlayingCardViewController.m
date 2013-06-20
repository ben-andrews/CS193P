//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Ben Andrews on 31/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"
#import "PlayingCardCollectionViewCell.h"
#import "FlipResultView.h"

@interface PlayingCardViewController()
@property (weak, nonatomic) IBOutlet FlipResultView *flipResultView;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation PlayingCardViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

#define NUM_CARDS 22;

- (NSUInteger)startingCardCount
{
    return NUM_CARDS;
}

#define NUM_CARDS_TO_MATCH 2;

- (NSUInteger)numCardsToMatch
{
    return NUM_CARDS_TO_MATCH;
}

- (NSString *)reuseIdentifier
{
    return @"PlayingCard";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

#define SHADING_ALPHA 0.3
#define FLIP_ANIMATION_DURATION 0.4

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animated:(BOOL)animated
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? SHADING_ALPHA : 1.0;
            
            if ((playingCard.isFaceUp) && (!playingCard.isUnplayable) && (animated)) {
            [UIView transitionWithView:cell
                              duration:FLIP_ANIMATION_DURATION
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:NULL
                            completion:NULL];
            }
        }
    }
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animated:YES];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self updateFlipResult];
}

#define SPACING 5
#define CARD_WIDTH 35
#define CARD_HEIGHT 50
#define FLIPPED_UP_LABEL_WIDTH 100
#define FLIPPED_UP_LABEL_HEIGHT 25
#define FLIPPED_UP_LABEL_Y_FACTOR 0.25

- (void)updateFlipResult
{
    [self removeSubviewsFromView:self.flipResultView];
    
    for (int i = 0; i < self.game.cardsFlipped.count; i++) {
        NSUInteger x = i * CARD_WIDTH;
        if (i != 0) x += SPACING;
        PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(x, 0, CARD_WIDTH, CARD_HEIGHT)];
        PlayingCard *card = self.game.cardsFlipped[i];
        cardView.rank = card.rank;
        cardView.suit = card.suit;
        cardView.faceUp = YES;
        cardView.opaque = NO;
        [self.flipResultView addSubview:cardView];
    }
    
    if (self.game.cardsFlipped.count) {
        UILabel *cardsFlippedLabel = [[UILabel alloc] initWithFrame:CGRectMake((CARD_WIDTH + SPACING) * self.game.cardsFlipped.count, CARD_HEIGHT * FLIPPED_UP_LABEL_Y_FACTOR, self.view.bounds.size.width - (CARD_WIDTH * self.game.cardsFlipped.count), FLIPPED_UP_LABEL_HEIGHT)];
        cardsFlippedLabel.text = [self getCardsFlippedMessageText];
        [self.flipResultView addSubview:cardsFlippedLabel];
    }
}

@end

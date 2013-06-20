//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ben Andrews on 24/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "FlipResultView.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet FlipResultView *flipResultView;
@end

@implementation CardGameViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 0; // abstract
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animated:(BOOL)animated { } // abstract

- (Deck *)createDeck { return nil; } // abstract

- (void)updateUI { } // abstract

- (void)updateFlipResult { } // abstract

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animated:NO];
    return cell;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                          usingDeck:[self createDeck]
                                                   withCardsToMatch:self.numCardsToMatch];
    return _game;
}

- (IBAction)flipCard:(UITapGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        [self updateUI];
    }
}

- (IBAction)deal
{
    self.game = nil;
    [self.cardCollectionView reloadData];
    [self updateUI];
}

- (IBAction)addThreeCards
{
    if ([self.game addThreeCards]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSUInteger section = [self.cardCollectionView numberOfSections]-1;
        for (int i = 0; i < 3; i++) {
            NSUInteger item = [self.cardCollectionView numberOfItemsInSection:section]+i;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [indexPaths addObject:indexPath];
        }
        [self.cardCollectionView insertItemsAtIndexPaths:indexPaths];
        [self.cardCollectionView scrollToItemAtIndexPath:indexPaths[0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:@"No more cards left in deck" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)removeSubviewsFromView:(UIView *)view
{
    NSArray *viewsToRemove = [view subviews];
    for (UIView *view in viewsToRemove) {
        [view removeFromSuperview];
    }
}

- (NSString *)getCardsFlippedMessageText
{
    NSString *messageText = [[NSString alloc] init];
    if (self.game.cardsFlipped.count < self.game.numCardsToMatch) {
        messageText = @"Flipped up";
    } else if ((self.game.cardsFlipped.count == self.game.numCardsToMatch) && (self.game.scoreChange > 0)) {
        messageText = [NSString stringWithFormat:@"Matched for %d points", self.game.scoreChange];
    } else if ((self.game.cardsFlipped.count == self.game.numCardsToMatch) && (self.game.scoreChange < 0)) {
        messageText = [NSString stringWithFormat:@"Don’t match! %d point penalty", self.game.scoreChange];
    }
    return messageText;
}

@end

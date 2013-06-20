//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Ben Andrews on 24/05/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) NSUInteger startingCardCount;
@property (nonatomic) NSUInteger numCardsToMatch;
@property (strong, nonatomic) NSString *reuseIdentifier;

- (void)removeSubviewsFromView:(UIView *)view;
- (NSString *)getCardsFlippedMessageText;

// abstract:
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animated:(BOOL)animated;
- (Deck *)createDeck;
- (void)updateUI;
- (void)updateFlipResult;


@end

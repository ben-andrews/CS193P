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
@property (nonatomic) NSUInteger cardCount;
@property (nonatomic) NSUInteger cardsToMatch;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
- (Deck *)createDeck;
- (void)updateUI;

@end

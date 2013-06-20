//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Ben Andrews on 12/06/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end

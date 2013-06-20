//
//  SetCardView.h
//  Matchismo
//
//  Created by Ben Andrews on 07/06/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger symbol;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) BOOL selected;

@end

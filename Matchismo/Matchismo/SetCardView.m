//
//  SetCardView.m
//  Matchismo
//
//  Created by Ben Andrews on 07/06/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "SetCardView.h"
#import "SetCard.h"

@implementation SetCardView

- (void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

#define diamond 1
#define oval 2
#define squiggle 3

- (void)drawRect:(CGRect)rect
{
    if (self.symbol == diamond)[self drawDiamonds];
    if (self.symbol == oval)[self drawOvals];
    if (self.symbol == squiggle)[self drawSquiggles];
}

#define SPACING_SCALE_FACTOR 0.1
#define DIAMOND_SCALE_FACTOR 0.18

- (void)drawDiamonds
{
    CGPoint centre = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat side = self.bounds.size.width * DIAMOND_SCALE_FACTOR;
    CGFloat spacing = self.bounds.size.width * SPACING_SCALE_FACTOR;
    
    NSMutableArray *points = [[NSMutableArray alloc] init]; // Left vertex
    
    if (self.number == 1) {
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(centre.x - side / 2, centre.y)]];
    } else if (self.number == 2) {
        [points addObject:[NSValue valueWithCGPoint:CGPointMake((centre.x - side) - spacing / 2, centre.y)]];
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(centre.x + spacing / 2, centre.y)]];
    } else if (self.number == 3) {
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(centre.x - (side / 2 + side + spacing), centre.y)]];
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(centre.x - side / 2, centre.y)]];
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(centre.x + side / 2 + spacing, centre.y)]];
    }
    
    for (NSValue *point in points) {
        [self drawDiamondFromPoint:[point CGPointValue] ofSize:side];
    }
}

- (void)drawDiamondFromPoint:(CGPoint)leftVertex ofSize:(CGFloat)size
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:leftVertex];
    [path addLineToPoint:CGPointMake(leftVertex.x + size / 2, leftVertex.y - size)];
    [path addLineToPoint:CGPointMake(leftVertex.x + size, leftVertex.y)];
    [path addLineToPoint:CGPointMake(leftVertex.x + size / 2, leftVertex.y + size)];
    [path closePath];
    
    [self.strokeColor setStroke];
    [self.fillColor setFill];
    [path stroke];
    [path fill];
}

#define OVAL_SCALE_FACTOR 0.35
#define OVAL_CORNER_RADIUS 15

- (void)drawOvals
{
    CGPoint centre = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2); // need generic shape method
    CGFloat length = self.bounds.size.width * OVAL_SCALE_FACTOR;
    CGFloat width = (self.bounds.size.width * OVAL_SCALE_FACTOR) / 2;
    CGFloat spacing = self.bounds.size.width * SPACING_SCALE_FACTOR;

    [self.strokeColor setStroke];
    [self.fillColor setFill];
    if (self.number == 1) {
        CGRect rect = CGRectMake(centre.x - width / 2, centre.y - length / 2, width, length);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:OVAL_CORNER_RADIUS];
        [path stroke];
        [path fill];
    } else if (self.number == 2) {
        CGRect lRect = CGRectMake((centre.x - width) - spacing / 2, centre.y - length / 2, width, length);
        CGRect rRect = CGRectMake(centre.x + spacing / 2, centre.y - length / 2, width, length);
        UIBezierPath *lPath = [UIBezierPath bezierPathWithRoundedRect:lRect cornerRadius:OVAL_CORNER_RADIUS];
        UIBezierPath *rPath = [UIBezierPath bezierPathWithRoundedRect:rRect cornerRadius:OVAL_CORNER_RADIUS];
        [lPath stroke]; [rPath stroke];
        [lPath fill]; [rPath fill];
    } else if (self.number == 3) {
        CGRect lRect = CGRectMake(centre.x - (width / 2 + width + spacing), centre.y - length / 2, width, length);
        CGRect mRect = CGRectMake(centre.x - width / 2, centre.y - length / 2, width, length);
        CGRect rRect = CGRectMake(centre.x + width / 2 + spacing, centre.y - length / 2, width, length);
        UIBezierPath *lPath = [UIBezierPath bezierPathWithRoundedRect:lRect cornerRadius:OVAL_CORNER_RADIUS];
        UIBezierPath *mPath = [UIBezierPath bezierPathWithRoundedRect:mRect cornerRadius:OVAL_CORNER_RADIUS];
        UIBezierPath *rPath = [UIBezierPath bezierPathWithRoundedRect:rRect cornerRadius:OVAL_CORNER_RADIUS];
        [lPath stroke]; [mPath stroke]; [rPath stroke];
        [lPath fill]; [mPath fill]; [rPath fill];
    }
}

#define SQUIGGLE_SCALE_FACTOR 0.45
#define CURVE_CTRL_POINT_FACTOR 0.5

- (void)drawSquiggles
{
    CGPoint centre = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2); // need generic shape method
    CGFloat length = self.bounds.size.width * SQUIGGLE_SCALE_FACTOR / 2;
    CGFloat width = (self.bounds.size.width * SQUIGGLE_SCALE_FACTOR) / 2.5;
    CGFloat spacing = self.bounds.size.width * SPACING_SCALE_FACTOR;
    
    NSMutableArray *points = [[NSMutableArray alloc] init]; // Left vertex
    
    if (self.number == 1) {
        [points addObject:[NSValue valueWithCGPoint:centre]];
    } else if (self.number == 2) {
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(centre.x - (width + spacing) / 2, centre.y)]];
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(centre.x + (width + spacing) / 2, centre.y)]];
    } else if (self.number == 3) {
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(centre.x - (width + spacing), centre.y)]];
        [points addObject:[NSValue valueWithCGPoint:centre]];
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(centre.x + width + spacing, centre.y)]];
    }
    
    for (NSValue *point in points) {
        [self drawSquiggleFromPoint:[point CGPointValue] ofLength:length ofWidth:width];
    }
}

- (void)drawSquiggleFromPoint:(CGPoint)centre ofLength:(CGFloat)length ofWidth:(CGFloat)width
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    // Top left
    [path moveToPoint:CGPointMake(centre.x - width / 2, centre.y - length / 2)];
    // Top right
    [path addQuadCurveToPoint:CGPointMake(centre.x + width / 2, centre.y - length / 2)
                 controlPoint:CGPointMake(centre.x, centre.y - length)];
    // Bottom Right
    [path addCurveToPoint:CGPointMake(centre.x + width / 2, centre.y + length / 2)
            controlPoint1:CGPointMake(centre.x + width * CURVE_CTRL_POINT_FACTOR, centre.y)
            controlPoint2:CGPointMake(centre.x, centre.y)];
    // Bottom Left
    [path addQuadCurveToPoint:CGPointMake(centre.x - width / 2, centre.y + length / 2)
                 controlPoint:CGPointMake(centre.x, centre.y + length)];
    // Back to top left
    [path addCurveToPoint:CGPointMake(centre.x - width / 2, centre.y - length / 2)
            controlPoint1:CGPointMake(centre.x - width * CURVE_CTRL_POINT_FACTOR, centre.y)
            controlPoint2:CGPointMake(centre.x, centre.y)];
    
    [self.strokeColor setStroke];
    [self.fillColor setFill];
    [path stroke];
    [path fill];
}

@end

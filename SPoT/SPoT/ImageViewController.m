//
//  ImageViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ImageViewController

#define MIN_ZOOM_SCALE 0.2
#define MAX_ZOOM_SCALE 5.0

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    self.scrollView.delegate = self;
    [self resetImage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView flashScrollIndicators];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    double heightZoomMin = self.scrollView.bounds.size.height / self.imageView.image.size.height;
    double widthZoomMin  = self.scrollView.bounds.size.width  / self.imageView.image.size.width;
    self.scrollView.zoomScale = MAX(widthZoomMin, heightZoomMin);
}



@end

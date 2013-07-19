//
//  ImageViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"
#import "SPoTAppDelegate.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation ImageViewController

#define MIN_ZOOM_SCALE 0.2
#define MAX_ZOOM_SCALE 5.0
#define BAR_BUTTON_TITLE @"Photos"

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = BAR_BUTTON_TITLE;
    NSArray *buttons = [NSArray arrayWithObject:barButtonItem];
    self.toolbar.items = buttons;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.toolbar.items = nil;
}

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
        
        [self.spinner startAnimating];
        NSURL *imageURL = self.imageURL;
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            SPoTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate incrementNetworkActivity];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
            [delegate decrementNetworkActivity];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            if (self.imageURL == imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        self.scrollView.zoomScale = 1.0;
                        self.scrollView.contentSize = image.size;
                        self.imageView.image = image;
                        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                        [self setZoomScale];
                    }
                    [self.spinner stopAnimating];
                });
            }
        });
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
    self.splitViewController.delegate = self;
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

- (void)setZoomScale
{
    double heightZoomMin = self.view.bounds.size.height / self.imageView.image.size.height;
    double widthZoomMin  = self.view.bounds.size.width  / self.imageView.image.size.width;
    self.scrollView.zoomScale = MAX(widthZoomMin, heightZoomMin);
}

@end

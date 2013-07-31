//
//  PhotosMapViewController.m
//  SPoT_CoreData
//
//  Created by Ben Andrews on 24/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "PhotosMapViewController.h"
#import "Photo+MKAnnotation.h"
#import "ImageCacheManager.h"

@interface PhotosMapViewController ()

@end

@implementation PhotosMapViewController

#define PHOTO_ENTITY @"Photo"
#define TITLE_ATTRIBUTE @"title"
#define IMAGE_SEGUE @"Show Image"

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

- (void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:PHOTO_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:TITLE_ATTRIBUTE ascending:NO]];
    request.predicate = nil; // all photos
    NSArray *photos = [self.managedObjectContext executeFetchRequest:request error:NULL];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photos];
    Photo *photo = [photos lastObject];
    if (photo) self.mapView.centerCoordinate = photo.coordinate;
}

// iPad
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self performSegueWithIdentifier:IMAGE_SEGUE sender:view];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:IMAGE_SEGUE sender:view];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:IMAGE_SEGUE]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *aView = sender;
            if ([aView.annotation isKindOfClass:[Photo class]]) {
                Photo *photo = aView.annotation;
                // Record that photo was viewed
                photo.lastViewed = [NSDate date];
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    NSURL *url = [NSURL URLWithString:[photo photoURL]];
                    NSString *photoID = [photo photoID];
                    if (![ImageCacheManager imageInCache:photoID]) {
                        [ImageCacheManager cacheImageFromUrl:url withFilename:photoID];
                    } else {
                        url = [ImageCacheManager urlForImage:photoID];
                    }
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[photo title]];
                }
            }
        }
    }
}

@end

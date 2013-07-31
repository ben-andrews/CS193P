//
//  MapViewController.m
//  SPoT_CoreData
//
//  Created by Ben Andrews on 24/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "MapViewController.h"
#import "SharedManagedDocument.h"

@interface MapViewController ()
@property (nonatomic) BOOL needUpdateRegion;
@end

@implementation MapViewController

#define ANNOTATION_REUSE_ID @"MapViewController"
#define CALLOUT_IMAGE_WIDTH 30
#define CALLOUT_IMAGE_HEIGHT 30
#define REGION_X -0.1
#define REGION_Y -0.1
#define REGION_WIDTH_LIMIT 20
#define REGION_HEIGHT_LIMIT 20

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.needUpdateRegion) [self updateRegion];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    if (!self.managedObjectContext) [self useDocument];
    self.needUpdateRegion = YES;
}

- (void)useDocument
{
    SharedManagedDocument *sharedDocument = [SharedManagedDocument sharedDocument];
    UIManagedDocument *document = sharedDocument.document;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[document fileURL] path]]) {
        [document saveToURL:[document fileURL]
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) self.managedObjectContext = document.managedObjectContext;
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) self.managedObjectContext = document.managedObjectContext;
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        if ([view.annotation respondsToSelector:@selector(thumbnailImage)]) {
            imageView.image = [view.annotation performSelector:@selector(thumbnailImage)];
        }
    }
}	

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseId = ANNOTATION_REUSE_ID;
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        view.canShowCallout = YES;
        
        // Only show rightCalloutAccessory on iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if ([mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
                view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            }
        }
        
        view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,CALLOUT_IMAGE_WIDTH,CALLOUT_IMAGE_HEIGHT)];
    }
    
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        imageView.image = nil;
        
        if ([view.annotation respondsToSelector:@selector(thumbnailImage)]) {
            imageView.image = [view.annotation performSelector:@selector(thumbnailImage)];
        }
    }
    return view;
}

- (void)updateRegion
{
    self.needUpdateRegion = NO;
    CGRect boundingRect;
    BOOL started = NO;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
        if (!started) {
            started = YES;
            boundingRect = annotationRect;
        } else {
            boundingRect = CGRectUnion(boundingRect, annotationRect);
        }
    }
    if (started) {
        boundingRect = CGRectInset(boundingRect, REGION_X, REGION_Y);
        if ((boundingRect.size.width < REGION_WIDTH_LIMIT) && (boundingRect.size.height < REGION_HEIGHT_LIMIT)) {
            MKCoordinateRegion region;
            region.center.latitude = boundingRect.origin.x + boundingRect.size.width / 2;
            region.center.longitude = boundingRect.origin.y + boundingRect.size.height / 2;
            region.span.latitudeDelta = boundingRect.size.width;
            region.span.longitudeDelta = boundingRect.size.height;
            [self.mapView setRegion:region animated:YES];
        }
    }
}

@end

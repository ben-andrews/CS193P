//
//  MapViewController.h
//  SPoT_CoreData
//
//  Created by Ben Andrews on 24/07/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//
//  Will display a thumbnail in leftCalloutAccessoryView if the
//  annotation implements the method "thumbnail" (return UIImage)
//
//  Icon provided under Creative Commons license, courtesy of http://icons8.com

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end

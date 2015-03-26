//
//  DirectionsViewController.m
//  PizzaHunter
//
//  Created by Micah Lanier on 3/25/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "DirectionsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DirectionsViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self goToLocation];
    self.mapView.showsUserLocation = YES;
    
}



- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonRenderer *aView = [[MKPolygonRenderer alloc] initWithOverlay:MKOverlayLevelAboveRoads];

        aView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        aView.lineWidth = 3;

        return aView;
    }
    return nil;
}

- (void)goToLocation {

    MKCoordinateRegion newRegion;

    newRegion.center.latitude = self.currentLocation.coordinate.latitude;
    newRegion.center.longitude = self.currentLocation.coordinate.longitude;

    newRegion.span.latitudeDelta = 0.024f;
    newRegion.span.longitudeDelta = 0.024f;

    [self.mapView setRegion:newRegion animated:YES];
    
}



@end

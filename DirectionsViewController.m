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

@interface DirectionsViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property NSMutableString *directionString;

@end

@implementation DirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self goToLocation];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = YES;
    [self.mapView addAnnotation:self.selectedPizzaPointAnnotation];


    CLLocationCoordinate2D coordinates[2] =
    {self.currentLocation.coordinate, self.selectedPizzaPointAnnotation.coordinate};

    MKGeodesicPolyline *geodesicPolyline =
    [MKGeodesicPolyline polylineWithCoordinates:coordinates
                                          count:2];

    [self.mapView addOverlay:geodesicPolyline];
    self.textView.text = self.directionString;
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if (![annotation isEqual:mapView.userLocation]) {
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        pin.image = [UIImage imageNamed:@"pizza"];
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        return pin;
    } else {
        return nil;
    }
}

//- (void)getDirectionsTo:(MKMapItem *)destinationItem {
//    MKDirectionsRequest *request = [MKDirectionsRequest new];
//    request.source = [MKMapItem mapItemForCurrentLocation];
//    request.destination = [[MKMapItem alloc] initWithPlacemark:self.selectedPizzeria.placemark];
//    request.transportType = MKDirectionsTransportTypeWalking;
//    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
//
//    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
//        MKRoute *route = response.routes.firstObject;
//        self.directionString = [NSMutableString new];
//        int counter = 1;
//
//        for (MKRouteStep *step in route.steps) {
//            [self.directionString appendFormat:@"%d: %@\n", counter, step.instructions];
//            counter++;
//        }
//    }];
//}




- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if (![overlay isKindOfClass:[MKPolyline class]]) {
        return nil;
    }

    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
    renderer.lineWidth = 3.0f;
    renderer.strokeColor = [UIColor blueColor];
    renderer.alpha = 0.5;

    return renderer;
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

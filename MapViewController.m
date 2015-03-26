//
//  MapViewController.m
//  PizzaHunter
//
//  Created by Micah Lanier on 3/25/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "MapViewController.h"
#import "Pizzeria.h"
#import "HomeViewController.h"
#import "DirectionsViewController.h"
#import "PizzaPointAnnotation.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property PizzaPointAnnotation *pizzaAnnotation;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self goToLocation];

    for (MKMapItem *mapItem in self.foundPizzerias) {
        self.pizzaAnnotation = [PizzaPointAnnotation new];
        self.pizzaAnnotation.coordinate = CLLocationCoordinate2DMake(mapItem.placemark.coordinate.latitude, mapItem.placemark.coordinate.longitude);
        self.pizzaAnnotation.title = mapItem.name;
        [self.mapView addAnnotation:self.pizzaAnnotation];
    }
    self.mapView.showsUserLocation = YES;
    self.textView.text = self.directions;

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


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    self.pizzaAnnotation.view = view;
    [self performSegueWithIdentifier:@"ShowDirectionsSegue" sender:control];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDirectionsSegue"]) {
        DirectionsViewController *directionsVC = [DirectionsViewController new];
        directionsVC = segue.destinationViewController;
        directionsVC.currentLocation = self.currentLocation;
        directionsVC.selectedPizzeria = self.mapPizzeria;
        directionsVC.selectedPizzaPointAnnotation = self.pizzaAnnotation;
    }
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

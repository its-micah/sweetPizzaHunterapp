//
//  HomeViewController.m
//  PizzaHunter
//
//  Created by Micah Lanier on 3/25/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "HomeViewController.h"
#import "Pizzeria.h"
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface HomeViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *pizzeriaArray;
@property NSString *address;
@property Pizzeria *pizzeria;
@property CLLocation *currentLocation;
@property MapViewController *mapVC;
@property NSMutableString *directionString;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pizzeriaArray = [NSMutableArray new];

    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;

}

- (IBAction)onFindPizzaButtonTapped:(UIButton *)sender {
    [self.locationManager startUpdatingLocation];
    NSLog(@"lookin for you gur");
}


- (void)findPizzeria:(CLLocation *)pizzeria {
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"pizzeria";
    request.region = MKCoordinateRegionMake(pizzeria.coordinate, MKCoordinateSpanMake(1, 1));
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];

    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        [self.pizzeriaArray addObjectsFromArray:response.mapItems];
        NSLog(@"%lu", self.pizzeriaArray.count);

        [self.tableView reloadData];
        [self getDirectionsTo:self.pizzeriaArray.firstObject];
    }];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 1000 && location.verticalAccuracy < 1000) {
            [self reverseGeoCode:location];
            [self.locationManager stopUpdatingLocation];
            NSLog(@"found you");
            break;
        }
    }
}

- (void)getDirectionsTo:(MKMapItem *)destinationItem {
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destinationItem;
    request.transportType = MKDirectionsTransportTypeWalking;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        MKRoute *route = response.routes.firstObject;
        self.directionString = [NSMutableString new];
        int counter = 1;

        for (MKRouteStep *step in route.steps) {
            [self.directionString appendFormat:@"%d: %@\n", counter, step.instructions];
            counter++;
        }
    }];
}

- (void)reverseGeoCode:(CLLocation *)location {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.firstObject;
        [self findPizzeria:placemark.location];
        self.currentLocation = placemark.location;
    }];
}

#pragma mark - "Prepare For Segue method"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *mapVC = segue.destinationViewController;
    mapVC.currentLocation = self.currentLocation;
    mapVC.foundPizzerias = self.pizzeriaArray;
    mapVC.directions = self.directionString;
    mapVC.title = @"Pizzerias";
}

#pragma mark "tableView delegate methods"

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pizzeriaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    self.pizzeria = [self.pizzeriaArray objectAtIndex:indexPath.row];
    cell.textLabel.text = self.pizzeria.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f mi", [self.currentLocation distanceFromLocation:self.pizzeria.placemark.location] * 0.00062137];
    return cell;
}




@end

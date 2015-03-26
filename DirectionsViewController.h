//
//  DirectionsViewController.h
//  PizzaHunter
//
//  Created by Micah Lanier on 3/25/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DirectionsViewController : UIViewController

@property CLLocation *currentLocation;
@property MKAnnotationView *annotationView;


@end

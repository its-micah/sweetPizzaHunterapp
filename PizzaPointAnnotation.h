//
//  PizzaPointAnnotation.h
//  PizzaHunter
//
//  Created by Micah Lanier on 3/25/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PizzaPointAnnotation : MKPointAnnotation

@property NSString *name;
@property double latitude;
@property double longitude;
@property MKAnnotationView *view;
@end

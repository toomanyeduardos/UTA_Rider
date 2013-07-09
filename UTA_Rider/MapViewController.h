//
//  MapViewController.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 6/14/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <OpenEars/FliteController.h>
#import <Slt/Slt.h>
#import <CoreLocation/CoreLocation.h>
#import "TrainStation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    NSUserDefaults *defaults;
    
    // For current location
    CLLocationManager *locationManager;
    MKCoordinateRegion region;
    CLLocation *userLocation;
    
    // For annotations...
    CLLocationCoordinate2D location;
    NSString *destinationTraxRed;
    NSString *destinationTraxGreen;
    NSString *destinationTraxBlue;

    // Toggle Switches
    NSString *traxRedLineSwitch;
    NSString *traxGreenLineSwitch;
    NSString *traxBlueLineSwitch;
    
    // Train Stations
    NSMutableArray *traxStations;
    //NSMutableArray *allStationsCLLocation;
    
    // Annotation Arrays
    NSMutableArray *traxRedLineArray;
    NSMutableArray *traxGreenLineArray;
    NSMutableArray *traxBlueLineArray;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) FliteController *fliteController;
@property (nonatomic, strong) Slt *slt;

- (IBAction)buttonFindClosest:(id)sender;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (CLLocationDistance)distanceFromLocation:(const CLLocation *)location;

- (void) checkSwitchStateFromRoutesTVC;
- (void) generateTrains;
- (void) generateTrainStations;
- (TrainStation *) getDistance;

- (NSMutableArray *) generateTraxRedLineAnnotations;
- (NSMutableArray *) generateTraxGreenLineAnnotations;
- (NSMutableArray *) generateTraxBlueLineAnnotations;


@end
















































//
//  MapViewController.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 6/14/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MapViewController.h"
#import "Annotation.h"
#import "AnnotationView.h"
#import "UTA_API_VEHICLE.h"

#define SPAN_VALUE 0.05

#define MURRAY_LATITUDE 40.6669
#define MURRAY_LONGITUDE -111.8872
#define METERS_TO_MILES 0.00062137

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView, locationManager, fliteController, slt;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkSwitchStateFromRoutesTVC];
    [self generateTrains];
    [self generateTrainStations];
    
    // Get device's current location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self; // send loc updates to myself
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void) checkSwitchStateFromRoutesTVC
{
    defaults = [NSUserDefaults standardUserDefaults];
    
    traxRedLineSwitch = [defaults objectForKey:@"TraxRedLine"];
    NSLog(@"In MapVC RedLineSwitch = %@", traxRedLineSwitch);
    
    traxGreenLineSwitch = [defaults objectForKey:@"TraxGreenLine"];
    NSLog(@"In MapVC GreenLineSwitch = %@", traxGreenLineSwitch);
    
    traxBlueLineSwitch = [defaults objectForKey:@"TraxBlueLine"];
    NSLog(@"In MapVC BlueLineSwitch = %@", traxBlueLineSwitch);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Make sure that location services are enabled
    if ( ![CLLocationManager locationServicesEnabled] )
    {
        NSLog(@"Location services are disabled");
    }
    
    //[self generateTrainStations];
    
    [self checkSwitchStateFromRoutesTVC];
    
    [self.mapView setDelegate:self];
    
    region.center.latitude = MURRAY_LATITUDE;
    region.center.longitude = MURRAY_LONGITUDE;
    region.span.latitudeDelta = 1;
    region.span.longitudeDelta = 1;
    [self.mapView setRegion:region animated:NO];
        
    // Arrays for annotations
    traxRedLineArray = [[NSMutableArray alloc]init];
    traxGreenLineArray = [[NSMutableArray alloc]init];
    traxBlueLineArray = [[NSMutableArray alloc]init];

    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(generateTrains) userInfo:nil repeats:YES];
    //[self generateTrains];
    
}

- (FliteController *) fliteController
{
    if (fliteController == nil)
    {
        fliteController = [[FliteController alloc]init];
    }
    return fliteController;
}

- (Slt *) slt
{
    if (slt == nil)
    {
        slt = [[Slt alloc]init];
    }
    return  slt;
}

- (IBAction)buttonFindClosest:(id)sender
{
    TrainStation *shortestDistance= [self getDistance];
    NSLog(@"\n");
    NSLog(@"Closest station = %@", [shortestDistance name]);
    NSLog(@"Distance to station = %@ meters", [shortestDistance distanceFromUser]);
    NSLog(@"Distance to station = %.2f miles", ([[shortestDistance distanceFromUser]doubleValue] * METERS_TO_MILES));
    
    NSString *message = [[NSString alloc]initWithFormat:@"The closest station is \"%@.\"\nThe distance from your location is %.2f miles.",
                         [shortestDistance name], ([[shortestDistance distanceFromUser]doubleValue] * METERS_TO_MILES)];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Closest Train Station"
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
    [self.fliteController say:message withVoice:self.slt];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
    location = [newLocation coordinate];
    
    NSLog(@"latitude = %f", location.latitude);
    
    region.center.latitude = location.latitude;
    region.center.longitude = location.longitude;
    region.span.latitudeDelta = SPAN_VALUE;
    region.span.longitudeDelta = SPAN_VALUE;
    [self.mapView setRegion:region animated:YES];

    mapView.showsUserLocation = YES;
    
    userLocation = newLocation;
    
    [locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // This is to display the blue dot in the user's location
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // create view (pin)
    AnnotationView *view = [[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    return view;
}//end mapView viewForAnnotation

- (void) generateTrainStations
{
    NSString *trainStationsFilePath = [[NSBundle mainBundle]pathForResource:@"trainStations" ofType:@"txt"];
    NSLog(@"trainStationsFilePath = %@", trainStationsFilePath);
    NSArray *allStations;
    
    if ([trainStationsFilePath length] > 0)
    {
        NSLog(@"File found");
        NSString* content = [NSString stringWithContentsOfFile:trainStationsFilePath
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        allStations = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    else
    {
        NSLog(@"File not found");
    }
    
    NSLog(@"all stations object 0 = %@",[allStations objectAtIndex:0]);
    NSLog(@"all stations object 1 = %@",[allStations objectAtIndex:1]);
    
    NSMutableArray *allStationsAnnotations = [[NSMutableArray alloc]init];
    traxStations = [[NSMutableArray alloc]init];
    Annotation *ann;
    
    for (int i = 0; i < [allStations count]; i++)
    {
        NSArray *station = [[allStations objectAtIndex:i]componentsSeparatedByString:@","];
        
        NSString *name = [station objectAtIndex:0];
        NSString *latitude = [station objectAtIndex:1];
        NSString *longitude = [station objectAtIndex:2];
        NSString *parking = [[NSString alloc]initWithFormat:@"Total Parking: %@",[station objectAtIndex:3]];
        
        NSLog(@"Lat = %f, Lon = %f, Parking = %@", latitude.doubleValue, longitude.doubleValue, parking);
    
        location.latitude = latitude.doubleValue;
        location.longitude = longitude.doubleValue;
        TrainStation *trainStation = [[TrainStation alloc]init];
        [trainStation setName:name];
        [trainStation setLatitude:latitude];
        [trainStation setLongitude:longitude];
        [trainStation setParking:parking];
        [trainStation setStationCLLocation:[[CLLocation alloc]initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]]];
        
        //CLLocation *stationCLLocation = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
        
        ann = [[Annotation alloc]init];
        [ann setCoordinate:location];
        ann.title = name;
        ann.subtitle = parking;
        [allStationsAnnotations addObject:ann];
        [traxStations addObject:trainStation];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{

    [mapView addAnnotations:allStationsAnnotations];
    });
    
}//end generateTrainStations

// This should be called from something like "getClosestStation" passing the current location as parameter
- (CLLocationDistance)distanceFromLocation:(const CLLocation *)locationParam
{
    CLLocationDistance distance = [locationParam distanceFromLocation:userLocation];
    return distance;
}

- (TrainStation *)getDistance
{
    NSMutableArray *allDistances = [[NSMutableArray alloc]init];

    
    // This may have to be "allStations" as an array with all data, instead of an array with just the CLLocations
    for (int i = 0; i < [traxStations count]; i++)
    {
        TrainStation *singleStation = [traxStations objectAtIndex:i];
        CLLocation *stationLocation = [singleStation stationCLLocation];
        NSLog(@"station name = %@", [singleStation name]);
        NSLog(@"station latitude = %@", [singleStation latitude]);
        NSNumber *singleDistance = [NSNumber numberWithFloat:[self distanceFromLocation:stationLocation]];
        [allDistances addObject:singleDistance];
        [singleStation setDistanceFromUser:singleDistance];
        NSLog(@"station singleDistance = %@", singleDistance);
        NSLog(@"\n");
    }

    double shortestDistance = [[allDistances objectAtIndex:0]doubleValue];
    int indexCounter = 0;
    
    for (int j = 0; j < [allDistances count]; j++)
    {
        if ([[allDistances objectAtIndex:j]doubleValue] < shortestDistance)
        {
            shortestDistance = [[allDistances objectAtIndex:j]doubleValue];
            indexCounter = j;
        }
    }
    
    return [traxStations objectAtIndex:indexCounter];
}//end getDistance


- (void) generateTrains
{       
    dispatch_queue_t downloader = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloader, ^{
       
        // deleting all annotations
        [mapView removeAnnotations:mapView.annotations];

        if ([traxRedLineSwitch isEqual:@"ON"])
        {
            [self generateTraxRedLineAnnotations];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [mapView addAnnotations:traxRedLineArray];                
            });
        }
        
        if ([traxGreenLineSwitch isEqual:@"ON"])
        {
            [self generateTraxGreenLineAnnotations];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [mapView addAnnotations:traxGreenLineArray];
            });
        }

        if ([traxBlueLineSwitch isEqual:@"ON"])
        {
            [self generateTraxBlueLineAnnotations];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [mapView addAnnotations:traxBlueLineArray];
            });
        }
    });
}

- (NSMutableArray *) generateTraxRedLineAnnotations
{
    UTA_API_VEHICLE *utaTrax703 = [[UTA_API_VEHICLE alloc]init];
    [traxRedLineArray removeAllObjects];
    Annotation *ann;
    
    // Red line 703
    NSData *line703 = [utaTrax703 getVehicleMonitorForRouteNumber:@"703"];
    [utaTrax703 parseVehicleMonotorData:line703];
    
    for (int i = 0; i < [[utaTrax703 latitude_arr]count]; i++)
    {
        //NSLog(@"red ann color = %@", ann.traxColor);
        
        location.latitude = [[[utaTrax703 latitude_arr]objectAtIndex:i]doubleValue];
        location.longitude = [[[utaTrax703 longitude_arr]objectAtIndex:i]doubleValue];
        
        //NSLog(@"red destination = %@", [[utaTrax703 destinationRef_arr]objectAtIndex:i]);
        
        if ([[[utaTrax703 destinationRef_arr]objectAtIndex:i]isEqualToString:@"TX101734"])
        {
            destinationTraxRed = @"Red To Daybreak";
        }
        else if ([[[utaTrax703 destinationRef_arr]objectAtIndex:i]isEqualToString:@"TX127252"])
        {
            destinationTraxRed = @"Red To University";
        }
        else
        {
            destinationTraxRed = @"No information available";
        }
        
        ann = [[Annotation alloc]init];
        [ann setCoordinate:location];
        ann.title = destinationTraxRed;
        ann.traxColor = @"red";
        [traxRedLineArray addObject:ann];
    }//end for
    
    return traxRedLineArray;
}//end generateTraxRedLineAnnotations

- (NSMutableArray *) generateTraxGreenLineAnnotations
{
    UTA_API_VEHICLE *utaTrax704 = [[UTA_API_VEHICLE alloc]init];
    [traxGreenLineArray removeAllObjects];
    Annotation *ann;
    
    // Green line 704
    NSData *line704 = [utaTrax704 getVehicleMonitorForRouteNumber:@"704"];
    [utaTrax704 parseVehicleMonotorData:line704];
    
    for (int i = 0; i < [[utaTrax704 latitude_arr]count]; i++)
    {
        //NSLog(@"green ann color = %@", ann.traxColor);
        
        location.latitude = [[[utaTrax704 latitude_arr]objectAtIndex:i]doubleValue];
        location.longitude = [[[utaTrax704 longitude_arr]objectAtIndex:i]doubleValue];
        
        //NSLog(@"green destination= %@", [[utaTrax704 destinationRef_arr]objectAtIndex:i]);
        
        if ([[[utaTrax704 destinationRef_arr]objectAtIndex:i]isEqualToString:@"TX173029"])
        {
            destinationTraxGreen = @"Green To Sandy";
        }
        else if ([[[utaTrax704 destinationRef_arr]objectAtIndex:i]isEqualToString:@"TX101394"])
        {
            destinationTraxGreen = @"Green To Downtown";
        }
        else if ([[[utaTrax704 destinationRef_arr]objectAtIndex:i]isEqualToString:@"0"])
        {
            destinationTraxGreen = @"Green destination = 0";
        }
        else
        {
            destinationTraxGreen = @"No information available";
        }
        
        ann = [[Annotation alloc]init];
        [ann setCoordinate:location];
        ann.title = destinationTraxGreen;
        ann.traxColor = @"green";
        
        [traxGreenLineArray addObject:ann];
    }//end for
    
    return traxGreenLineArray;
}//end generateTraxGreenLineAnnotations

- (NSMutableArray *) generateTraxBlueLineAnnotations
{
    UTA_API_VEHICLE *utaTrax701 = [[UTA_API_VEHICLE alloc]init];
    [traxBlueLineArray removeAllObjects];
    Annotation *ann;
    
    // Blue line 701
    NSData *line701 = [utaTrax701 getVehicleMonitorForRouteNumber:@"701"];
    [utaTrax701 parseVehicleMonotorData:line701];
    for (int i = 0; i < [[utaTrax701 latitude_arr]count]; i++)
    {
        //NSLog(@"blue ann color = %@", ann.traxColor);
        
        location.latitude = [[[utaTrax701 latitude_arr]objectAtIndex:i]doubleValue];
        location.longitude = [[[utaTrax701 longitude_arr]objectAtIndex:i]doubleValue];
        
        //NSLog(@"blue destination= %@", [[utaTrax701 destinationRef_arr]objectAtIndex:i]);
        
        if ([[[utaTrax701 destinationRef_arr]objectAtIndex:i]isEqualToString:@"TX173029"])
        {
            destinationTraxBlue = @"Blue To Sandy";
        }
        else if ([[[utaTrax701 destinationRef_arr]objectAtIndex:i]isEqualToString:@"TX101394"])
        {
            destinationTraxBlue = @"Blue To Downtown";
        }
        else
        {
            destinationTraxBlue = @"No information available";
        }
        
        ann = [[Annotation alloc]init];
        [ann setCoordinate:location];
        ann.title = destinationTraxBlue;
        ann.traxColor = @"blue";
        [traxBlueLineArray addObject:ann];
    }//end for
    
    return traxBlueLineArray;
}//end generateTraxBlueLineAnnotations

- (void)mapView:(MKMapView *)mapview regionWillChangeAnimated:(BOOL)animated
{
    
    for (int i=0;i< [mapview.annotations count];i++)
    {
        id annotation = [mapview.annotations objectAtIndex:i];
        
        MKAnnotationView* annView =[mapview viewForAnnotation: annotation];
        if (annView != nil)
        {
            
            CALayer* layer = annView.layer;
            [layer removeAllAnimations];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}
@end



















































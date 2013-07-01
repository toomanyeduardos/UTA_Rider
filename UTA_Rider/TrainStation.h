//
//  TrainStation.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 6/28/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TrainStation : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *parking;
@property (nonatomic, retain) CLLocation *stationCLLocation;
@property (nonatomic, retain) NSNumber *distanceFromUser;

@end

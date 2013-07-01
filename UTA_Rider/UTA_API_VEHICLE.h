//
//  UTA_API.h
//  Test_UTA_API
//
//  Created by Eduardo Flores on 1/19/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTA_API_VEHICLE : NSObject
{
    NSData *vehicleMonitorData;
    BOOL gotData;
    NSInteger depth;
    NSString *currentElement;
}

@property (nonatomic, retain) NSMutableArray *recordedAtTime_arr;
@property (nonatomic, retain) NSMutableArray *lineRef_arr;
@property (nonatomic, retain) NSMutableArray *dataFrameRef_arr;
@property (nonatomic, retain) NSMutableArray *datedVehicleJourneyRef_arr;
@property (nonatomic, retain) NSMutableArray *publishedLineName_arr;
@property (nonatomic, retain) NSMutableArray *originRef_arr;
@property (nonatomic, retain) NSMutableArray *destinationRef_arr;
@property (nonatomic, retain) NSMutableArray *longitude_arr;
@property (nonatomic, retain) NSMutableArray *latitude_arr;

- (NSData *)getVehicleMonitorForRouteNumber: (NSString *)routeNumber;
- (void) parseVehicleMonotorData:(NSData *)data;

@end

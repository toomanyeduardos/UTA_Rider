//
//  Annotation.h
//  Test_SimpleMapCentering
//
//  Created by Eduardo Flores on 1/3/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

// coordinate (mandatory)
// title
// subtitle

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *traxColor;

- initWithPosition:(CLLocationCoordinate2D) coords;

@end

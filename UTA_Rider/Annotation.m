//
//  Annotation.m
//  Test_SimpleMapCentering
//
//  Created by Eduardo Flores on 1/3/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize coordinate, title, subtitle;
@synthesize traxColor;

- initWithPosition:(CLLocationCoordinate2D)coords
{
    if (self = [super init])
    {
        self.coordinate = coords;
    }
    return self;
}

@end

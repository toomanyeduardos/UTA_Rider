//
//  AnnotationView.m
//  Test_SimpleMapCentering
//
//  Created by Eduardo Flores on 1/21/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

#import "AnnotationView.h"
#import "Annotation.h"

@implementation AnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    
    // annotation
    Annotation *myAnnotation = (Annotation *)annotation;
    
    if ([myAnnotation.traxColor isEqualToString:@"red"])
    {
        self.image = [UIImage imageNamed:@"train_red.png"];
    }
    else if ([myAnnotation.traxColor isEqualToString:@"blue"])
    {
        self.image = [UIImage imageNamed:@"train_blue.png"];
    }
    else if ([myAnnotation.traxColor isEqualToString:@"green"])
    {
        self.image = [UIImage imageNamed:@"train_green.png"];
    }
    else if ([myAnnotation.traxColor isEqualToString:@"frontrunner"])
    {
        self.image = [UIImage imageNamed:@"frontrunner_north.png"];
    }
    else
    {
        self.image = [UIImage imageNamed:@"train_station.png"];
    }
    
    self.enabled = YES;
    self.canShowCallout = YES;
    
    return self;
}

@end



















































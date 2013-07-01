//
//  RoutesTableViewController.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 6/14/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoutesTableViewController : UITableViewController
{
    NSUserDefaults *defaults;
}

- (void) switchTouched:(id)sender;

@end

//
//  RoutesTableViewController.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 6/14/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

#import "RoutesTableViewController.h"
#import "RoutesTableCell.h"
//#import "UTA_API_STOPS.h"

@interface RoutesTableViewController ()

@end

@implementation RoutesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UTA_API_STOPS *stops = [[UTA_API_STOPS alloc]init];
    //[stops getStopMonitorForStopId:@"TX153041"];
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defaults dictionaryRepresentation];
    
    for (id key in dict)
    {
        [defaults removeObjectForKey:key];
    }
    
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Trax Lines";
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RoutesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row)
    {
        case 0:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[cell cellLabel] setText:@"Red Line"];
            [[cell cellSwitch] setOn:NO];
            [[cell cellSwitch] setTag:0];
            [[cell cellSwitch] addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
            break;
        case 1:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[cell cellLabel] setText:@"Green Line"];
            [[cell cellSwitch] setOn:NO];
            [[cell cellSwitch] setTag:1];
            [[cell cellSwitch] addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
            break;
        case 2:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[cell cellLabel] setText:@"Blue Line"];
            [[cell cellSwitch] setOn:NO];
            [[cell cellSwitch] setTag:2];
            [[cell cellSwitch] addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
            break;
    }
    return cell;
}

- (void) switchTouched:(id)sender
{
    UISwitch *switchButton = sender;
    NSString *switchState = switchButton.on ? @"ON" : @"OFF";
    NSString *whichSwitchButton = [[NSString alloc]init];
    
    switch (switchButton.tag)
    {
        case 0:
            whichSwitchButton = @"TraxRedLine";
            break;
        case 1:
            whichSwitchButton = @"TraxGreenLine";
            break;
        case 2:
            whichSwitchButton = @"TraxBlueLine";
            break;
    }
    
    NSLog(@"In RoutesTVC the switch %@ is %@", whichSwitchButton, switchState);
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:switchState forKey:whichSwitchButton];
    [defaults synchronize];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end



















































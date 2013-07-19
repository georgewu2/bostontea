//
//  TripPlannerViewController.m
//  Where's My T
//
//  Created by George Wu on 1/21/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import "TripPlannerViewController.h"

@interface TripPlannerViewController ()

@end

@implementation TripPlannerViewController

@synthesize startStation;
@synthesize endStation;
@synthesize customPicker;
@synthesize picker;
@synthesize userSelect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // set background to custom image
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"TripPlanner.png"]];
    
    NSMutableArray *allStations = [[NSMutableArray alloc] init];
    [allStations addObjectsFromArray:[Search redStations]];
    [allStations addObjectsFromArray:[Search orangeStations]];
    [allStations addObjectsFromArray:[Search blueStations]];
    [allStations addObjectsFromArray:[Search greenStations]];
    [allStations addObjectsFromArray:[Search silverStations]];
    NSArray *allStationsSorted = [allStations sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableSet *existingNames = [NSMutableSet set];
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString *obj in allStationsSorted) {
        if (![existingNames containsObject:obj]) {
            [result addObject:obj];
            [existingNames addObject:obj];
        }
    }
    pickerArray = result;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// set up picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // stores location number of user selection in userSelect
    userSelect = row;
}

- (IBAction)stationSelect:(id)sender
{
    // slide the picker up when user wants to select station
    [UIView beginAnimations: @"SlideIn" context: nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGRect pickerFrame = self.customPicker.frame;
    pickerFrame.origin.y = 160;
    self.customPicker.frame = pickerFrame;
    [UIView commitAnimations];
    tag = [sender tag];
}

- (IBAction)done:(id)sender
{
    // slide picker down
    [UIView beginAnimations: @"SlideIn" context: nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGRect pickerFrame = self.customPicker.frame;
    pickerFrame.origin.y = 480;
    self.customPicker.frame = pickerFrame;
    [UIView commitAnimations];
    
    // set label in button to station name
    if (tag == 0)
        [startStation setTitle:[pickerArray objectAtIndex:userSelect] forState: UIControlStateNormal];
    else if (tag == 1)
        [endStation setTitle:[pickerArray objectAtIndex:userSelect] forState:UIControlStateNormal];
}

- (IBAction)submit:(id)sender
{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"You need to have Google Maps installed in order to use trip planner!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    // stop segue and alert user if starting or ending station has not been selected
    else if ([startStation.titleLabel.text isEqualToString:@"Select a Station"] || [endStation.titleLabel.text isEqualToString:@"Select a Station"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You must select a starting and/or ending station!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        NSString *start = startStation.titleLabel.text;
        NSString *end = endStation.titleLabel.text;
        if (!([start isEqualToString:@"North Station"] || [start isEqualToString:@"South Station"]))
        {
            start = [start stringByAppendingString:@" Station"];
        }
        if (!([end isEqualToString:@"North Station"] || [end isEqualToString:@"South Station"]))
        {
            end = [end stringByAppendingString:@" Station"];
        }
    
        NSString *urlString = [[NSString alloc] initWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@&center=42.356007,-71.085062&directionsmode=transit&zoom=10", start, end];
        urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSLog(@"%@", urlString);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    }
}

@end

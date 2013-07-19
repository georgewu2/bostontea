//
//  BlueLineViewController.m
//  Where's My T?
//
//  Created by George Wu on 12/6/12.
//  Copyright (c) 2012 George Luke. All rights reserved.
//

#import "BlueLineViewController.h"

@interface BlueLineViewController ()

@end

@implementation BlueLineViewController

@synthesize station;
@synthesize picker;
@synthesize dataView;
@synthesize data;
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
	
    // fill picker with stations
    pickerArray = [Search blueStations];
    
    // set background to custom image
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bluetrain.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    CGRect pickerFrame = self.picker.frame;
    pickerFrame.origin.y = 200;
    self.picker.frame = pickerFrame;
    [UIView commitAnimations];
}

- (IBAction)submitClicked:(id)sender
{
    // slide the picker down
    [UIView beginAnimations: @"SlideIn" context: nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGRect pickerFrame = self.picker.frame;
    pickerFrame.origin.y = 480;
    self.picker.frame = pickerFrame;
    [UIView commitAnimations];
    
    // set the label in the station button to the station name
    [station setTitle:[pickerArray objectAtIndex:userSelect] forState: UIControlStateNormal];
    
    // create an error object
    NSError *error = nil;
    
    // finds all trains that are going to a destination and are near a specific station and stores them in an array
    NSMutableArray *trains = [Search searchMBTA:@"blue"
                                 andDestination: [Segment titleForSegmentAtIndex:[Segment selectedSegmentIndex]]
                                     andStation: [pickerArray objectAtIndex:userSelect]
                                       andError: &error];
    
    // if there are no objects, then the T is not running
    int num = [trains count];
    if (num == 0)
    {
        data = @"The T is not running or there is no direct route from your location in that direction.";
    }
    else
    {
        // create data string
        data = [NSString stringWithFormat:@"The next train(s) arriving at %@ in the direction of %@ will arrive in ", [pickerArray objectAtIndex:userSelect], [Segment titleForSegmentAtIndex:[Segment selectedSegmentIndex]]];
        
        // for grammar
        int count = 0;
        
        for (NSNumber *seconds in trains)
        {
            // convert seconds to minutes
            int s = [seconds intValue];
            int m = s / 60;
            s = s % 60;
            
            // create appending strings
            NSString *append1 = [NSString stringWithFormat:@"%d", m];
            NSString *append2 = [NSString stringWithFormat:@"%d", s];
            
            if ([seconds intValue] > 0)
            {
                data = [data stringByAppendingString:append1];
                data = [data stringByAppendingString:@" minutes "];
                data = [data stringByAppendingString:append2];
                data = [data stringByAppendingString:@" seconds"];
                if (count < num - 1)
                {
                    data = [data stringByAppendingString:@", "];
                }
                else
                {
                    data = [data stringByAppendingString:@"."];
                }
            }
            count++;
        }
    }
    
    // display the data on the screen
    dataView.text = data;
}




@end

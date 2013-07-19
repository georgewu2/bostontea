//
//  SingleLineViewController.m
//  Where's My T
//
//  Created by George Wu on 1/20/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import "SingleLineViewController.h"
#import "ResultsViewController.h"

@interface SingleLineViewController ()

@end

@implementation SingleLineViewController

@synthesize color;
@synthesize startStation;
@synthesize endStation;
@synthesize customPicker;
@synthesize picker;
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
	// Do any additional setup after loading the view.
    
    // fill picker with stations
    if ([color isEqualToString: @"red"])
    {
        // get red stations
        pickerArray = [Search redStations];
        
        // set background to custom image
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BackgroundRed.png"]];
    }
    else if ([color isEqualToString: @"orange"])
    {
        // get orange stations
        pickerArray = [Search orangeStations];
        
        // set background to custom image
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BackgroundOrange.png"]];
    }
    else if ([color isEqualToString: @"blue"])
    {
        // get blue stations
        pickerArray = [Search blueStations];
        
        // set background to custom image
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BackgroundBlue"]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    {
        [startStation setTitle:[pickerArray objectAtIndex:userSelect] forState: UIControlStateNormal];
        startId = userSelect;
    }
    else if (tag == 1)
    {
        [endStation setTitle:[pickerArray objectAtIndex:userSelect] forState:UIControlStateNormal];
        endId = userSelect;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // stop segue and alert user if starting or ending station has not been selected
    if ([identifier isEqualToString:@"submit"] && ([startStation.titleLabel.text isEqualToString:@"Select a Station"] || [endStation.titleLabel.text isEqualToString:@"Select a Station"]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You must select a starting and/or ending station!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    // stop segue and alert user if both starting and ending stations are the same
    else if ([identifier isEqualToString:@"submit"] && startId == endId)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You must select two different stations!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    // proceed with segue
    else
        return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"submit"])
    {
        // direction for station
        NSString *direction;
        
        if ([color isEqualToString:@"red"])
        {
            // starting after ending
            if (startId > endId)
                direction = @"Alewife";
            
            // starting in ashmont branch
            else if (startId > 17)
                direction = @"Ashmont";
            
            // starting and ending in braintree branch
            else if (startId > 12 && endId < 18)
                direction = @"Braintree";
            
            // starting in braintree branch and ending in ashmont
            else if (startId > 12 && endId > 17)
                direction = @"Alewife";
            
            // else ending in ashmont and starting on main
            else if (endId > 17)
                direction = @"Ashmont";
            
            // else ending in braintree and starting on main
            else if (endId > 12)
                direction = @"Braintree";
            
            // else starting and ending in main
            else
            {
                direction = @"Ashmont/Braintree";
            }
        }
        else if ([color isEqualToString:@"orange"])
        {
            // towards Oak Grove
            if (startId > endId)
                direction = @"Oak Grove";
            
            // towards Forest Hills
            else if (startId < endId)
                direction = @"Forest Hills";
        }
        else
        {
            // towards Wonderland
            if (startId > endId)
                direction = @"Wonderland";
            
            // towards Bowdoin
            else if (startId < endId)
                direction = @"Bowdoin";
        }
        // segue to ResultsViewController
        ResultsViewController *controller = (ResultsViewController *)segue.destinationViewController;
        controller.color = color;
        controller.station = startStation.titleLabel.text;
        controller.direction = direction;
    }
}

@end

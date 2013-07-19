//
//  ResultsViewController.m
//  Where's My T
//
//  Created by George Wu on 1/22/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

@synthesize color;
@synthesize station;
@synthesize direction;
@synthesize allTrains;
@synthesize noWifi;
@synthesize name, destination;
@synthesize table;

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
    if ([color isEqualToString: @"red"])
    {
        // set background to custom image
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BackgroundRed.png"]];
    }
    else if ([color isEqualToString: @"orange"])
    {
        // set background to custom image
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BackgroundOrange.png"]];
    }
    else if ([color isEqualToString: @"blue"])
    {
        // set background to custom image
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BackgroundBlue"]];
    }
    name.text = [station stringByAppendingString:@" Station"];
    name.textAlignment = NSTextAlignmentCenter;
    destination.text = [@"Towards " stringByAppendingString:direction];
    destination.textAlignment = NSTextAlignmentCenter;
    // get latest trains
    allTrains = [self update];
    if (noWifi)
    {
        NSString *errorMessage = [[noWifi userInfo] objectForKey:NSLocalizedDescriptionKey];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh-Oh!"
                                                        message:errorMessage
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [NSTimer scheduledTimerWithTimeInterval: 10.0
                                     target: self
                                   selector: @selector(callAfterTenSeconds:)
                                   userInfo: nil
                                    repeats: YES];
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
    return [allTrains count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get the current time
    NSDate *currentTime = [NSDate date];
    
    // make separate formatters for each section of time
    NSDateFormatter *hoursFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *minutesFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *secondsFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *ampmFormatter = [[NSDateFormatter alloc] init];
    
    // set up formatters
    [hoursFormatter setDateFormat:@"hh"];
    [minutesFormatter setDateFormat:@"mm"];
    [secondsFormatter setDateFormat:@"ss"];
    [ampmFormatter setDateFormat:@"a"];
    
    // convert to strings
    NSString *hours = [hoursFormatter stringFromDate: currentTime];
    NSString *minutes = [minutesFormatter stringFromDate:currentTime];
    NSString *seconds = [secondsFormatter stringFromDate:currentTime];
    NSString *ampm = [ampmFormatter stringFromDate:currentTime];
    
    // convert strings to integers
    int h = [hours intValue];
    int m = [minutes intValue];
    int s = [seconds intValue];
    
    
    // find out how many seconds until next train
    int secondsAdding = [[allTrains objectAtIndex:[indexPath row]] intValue];
    
    // for negative values, change to 0
    if (secondsAdding < 0)
    {
        secondsAdding = 0;
    }
    
    // add to current seconds
    s+= secondsAdding;
    
    // get how many minutes from seconds
    int minutesAdding = s / 60;
    
    // set s to remainder
    s = s % 60;
    
    // add to current minutes
    m+= minutesAdding;
    
    // get how many hours from minutes
    int hoursAdding = m / 60;
    
    // set m to remainder
    m = m % 60;
    
    // add to current hours
    int newHours = h + hoursAdding;
    
    // wrap around hours if necessary
    newHours = (newHours - 1) % 12 + 1;
    
    // if time goes from 11 to 12, change AM to PM and vice versa
    if (h == 11 && newHours == 12)
    {
        if ([ampm isEqualToString:@"AM"])
        {
            ampm = @"PM";
        }
        else
        {
            ampm = @"AM";
        }
    }
    
    // make a string that has time of arrival and number of minutes until arrival
    NSString *result = [NSString stringWithFormat:@"%02d:%02d %@ - %d min %d sec", newHours,m,ampm,secondsAdding / 60, secondsAdding % 60];
    
    // for reuse
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    // Configure the cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = result;
    
    // change cell font to avenir
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:17.0];

    return cell;
}

- (NSMutableArray *)update
{
    // create an error object
    NSError *error = nil;
    
    NSMutableArray *trains;
    
    // branch doesn't matter so get all trains going to both braintree and ashmont
    if ([direction isEqualToString:@"Ashmont/Braintree"])
    {
        // get red line trains going towards braintree with predictions at startStation
        trains = [Search searchMBTA: color
                     andDestination: @"Braintree"
                         andStation: station
                           andError: &error];
        
        // get red line trains going towards ashmont with predictions at startStation
        NSMutableArray *trains2 = [Search searchMBTA: color
                                      andDestination: @"Ashmont"
                                          andStation: station
                                            andError: &error];
        
        // combine the two arrays
        [trains addObjectsFromArray:trains2];
    }
    else
    {
        // get color line trains going towards direction with predictions at startStation
        trains = [Search searchMBTA: color
                     andDestination: direction
                         andStation: station
                           andError: &error];
    }
    
    noWifi = error;
    
    // sort the times in the array of predictions
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [trains sortUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];
    
    return trains;
}

- (void)callAfterTenSeconds:(NSTimer *)t
{
    // get latest trains
    allTrains = [self update];
    
    // reload the table
    [self.table reloadData];
}

@end

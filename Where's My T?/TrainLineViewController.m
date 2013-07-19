//
//  TrainLineViewController.m
//  Where's My T
//
//  Created by George Wu on 12/6/12.
//  Copyright (c) 2012 George Wu. All rights reserved.
//

#import "TrainLineViewController.h"
#import "SingleLineViewController.h"

@interface TrainLineViewController ()

@end

@implementation TrainLineViewController

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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"MainScreen.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RedSegue"])
    {
        SingleLineViewController *controller = (SingleLineViewController *)segue.destinationViewController;
        controller.color = @"red";
    }
    else if ([segue.identifier isEqualToString:@"OrangeSegue"])
    {
        SingleLineViewController *controller = (SingleLineViewController *)segue.destinationViewController;
        controller.color = @"orange";
    }
    else if ([segue.identifier isEqualToString:@"BlueSegue"])
    {
        SingleLineViewController *controller = (SingleLineViewController *)segue.destinationViewController;
        controller.color = @"blue";
    }
}

@end

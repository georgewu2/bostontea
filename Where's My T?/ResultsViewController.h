//
//  ResultsViewController.h
//  Where's My T
//
//  Created by George Wu on 1/22/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Search.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UILabel *name, *destination;
    UITableView *table;
}

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *station;
@property (nonatomic, copy) NSString *direction;
@property (nonatomic, strong) NSMutableArray *allTrains;
@property (nonatomic, strong) NSError *noWifi;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *destination;
@property (nonatomic, strong) IBOutlet UITableView *table;

- (NSMutableArray *) update;
- (void) callAfterTenSeconds: (NSTimer *) t;

@end

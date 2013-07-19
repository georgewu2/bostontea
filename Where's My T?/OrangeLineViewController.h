//
//  OrangeLineViewController.h
//  Where's My T?
//
//  Created by George Wu on 12/6/12.
//  Copyright (c) 2012 George Luke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Search.h"

@interface OrangeLineViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    UIButton *station;
    UIPickerView *picker;
    NSArray *pickerArray;
    IBOutlet UISegmentedControl *Segment;
}

@property (nonatomic, strong) IBOutlet UIButton *station;
@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) IBOutlet UILabel*dataView;
@property (nonatomic, strong) NSString *data;
@property (nonatomic) NSInteger userSelect;

- (IBAction)stationSelect:(id)sender;
- (IBAction)submitClicked:(id)sender;

@end

//
//  SingleLineViewController.h
//  Where's My T
//
//  Created by George Wu on 1/20/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Search.h"

@interface SingleLineViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    UIButton *startStation;
    UIButton *endStation;
    UIView *customPicker;
    UIPickerView *picker;
    NSArray *pickerArray;
    NSUInteger tag, startId, endId;
}

@property (nonatomic, copy) NSString *color;
@property (nonatomic, strong) IBOutlet UIButton *startStation;
@property (nonatomic, strong) IBOutlet UIButton *endStation;
@property (nonatomic, strong) IBOutlet UIView *customPicker;
@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (nonatomic, copy) NSString *data;
@property (nonatomic) NSInteger userSelect;


- (IBAction)stationSelect:(id)sender;
- (IBAction)done:(id)sender;


@end

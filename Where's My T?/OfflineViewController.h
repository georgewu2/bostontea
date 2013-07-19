//
//  OfflineViewController.h
//  Where's My T
//
//  Created by George Wu on 1/20/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Search.h"

@interface OfflineViewController : UITableViewController {
    NSArray *tableArray;
}

@property (nonatomic, copy) NSString *color;

@end

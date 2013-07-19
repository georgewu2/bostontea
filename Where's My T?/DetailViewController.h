//
//  DetailViewController.h
//  Where's My T
//
//  Created by George Wu on 1/26/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSDictionary *titleWithDescription;

@end

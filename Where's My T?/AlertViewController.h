//
//  AlertViewController.h
//  Where's My T
//
//  Created by George Wu on 1/26/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlertViewController : UITableViewController <NSXMLParserDelegate, UITableViewDelegate> {
    NSMutableArray *titles;
    NSMutableArray *descriptions;
    NSMutableString *value;
    NSXMLParser *parser;
}

@end

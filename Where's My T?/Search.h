//
//  Search.h
//  MBTASubwaySearch
//
//  Created by Luke Chang on 12/6/12.
//  Copyright (c) 2012 Luke Chang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Search : NSObject

+ (NSMutableArray *) searchMBTA:(NSString *)line andDestination:(NSString *)destination andStation:(NSString *)station andError:(NSError**)error;

+ (NSMutableArray *) searchNavData:(NSString *)line andDestination:(NSString*)destination andError:(NSError**)error;

+ (NSArray *) redStations;
+ (NSArray *) blueStations;
+ (NSArray *) orangeStations;
+ (NSArray *) greenStations;
+ (NSArray *) silverStations;
+ (NSArray *) redStationsOrdered;
+ (NSArray *) blueStationsOrdered;
+ (NSArray *) orangeStationsOrdered;
@end

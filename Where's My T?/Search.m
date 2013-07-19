//
//  Search.m
//  MBTASubwaySearch
//
//  Created by Luke Chang on 12/6/12.
//  Copyright (c) 2012 Luke Chang. All rights reserved.
//
//  Usage: #import Search.h
// 

#import "Search.h"
#import <Foundation/NSJSONSerialization.h>

@implementation Search

//[Class Method]: returns a NSMutableArray containing trip prediction info for all trains heading towards NSString destination on NSString line and will stop at NSString station
+ (NSMutableArray *) searchMBTA:(NSString *)line andDestination:(NSString *)destination andStation:(NSString *)station andError:(NSError**)error;
{
    
    //determine URL from which to parse JSON
    NSURL *jsonURL;
    
    //red line
    if (![line compare:@"red" options:1])
    {
        jsonURL = [NSURL URLWithString:@"http://developer.mbta.com/lib/rthr/red.json"];
    }
    
    //else blue
    else if (![line compare:@"blue" options:1])
    {
        jsonURL = [NSURL URLWithString:@"http://developer.mbta.com/lib/rthr/blue.json"];
    }
    
    //else orange NOTE: sole "else" condition is not used to error-check NSString passed
    else if (![line compare:@"orange" options:1])
    {
        jsonURL = [NSURL URLWithString:@"http://developer.mbta.com/lib/rthr/orange.json"];
    }
    
    //store pure JSON inside data file
    NSData *jsonPure = [NSData dataWithContentsOfURL:jsonURL options:0 error:error];
    
    //check if JSON retrieval succeeded
    if (jsonPure == nil)
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setObject:@"Failed to retrieve JSON data. Please check your connection to the Internet." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"searchMBTA" code:1 userInfo:errorDetail];
        return nil;
    }
    
    //parse JSON into dictionary of Foundation objects using NSJsonSerialization
    NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonPure
                                                                options:0
                                                                  error:error];
    
    //check for parse success
    if (jsonPure == nil)
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setObject:@"Failed to parse JSON data." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"searchMBTA" code:2 userInfo:errorDetail];
        return nil;
    }
    
    //dive into parsed json dictionary to create array of trip dictionaries
    NSDictionary *triplist = [[jsonObjects objectForKey:@"TripList"]objectForKey:@"Trips"];
    
    //alloc array to store search results
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    //perform search
    for (NSDictionary *train in triplist)
    {
        
        if (![[train objectForKey:@"Destination"] compare:destination options:1])
        {
            NSArray *predictions = [train objectForKey:@"Predictions"];
            for (NSDictionary *info in predictions)
            {
                if (![[info objectForKey:@"Stop"] compare:station options:1])
                {
                    //place results into results array
                    [results addObject:[info objectForKey:@"Seconds"]];
                }
                
            }
        }
    }
    
    //sort resultant array
    [results sortUsingSelector:@selector(compare:)];
    
    //return resultant array
    return results;
}

+ (NSMutableArray *) searchNavData:(NSString *)line andDestination:(NSString*)destination andError:(NSError**)error
{
    //determine URL from which to parse JSON
    NSURL *jsonURL;
    
    //red line
    if (![line compare:@"red" options:1])
    {
        jsonURL = [NSURL URLWithString:@"http://developer.mbta.com/lib/rthr/red.json"];
    }
    
    //else blue
    else if (![line compare:@"blue" options:1])
    {
        jsonURL = [NSURL URLWithString:@"http://developer.mbta.com/lib/rthr/blue.json"];
    }
    
    //else orange NOTE: sole "else" condition is not used to error-check NSString passed
    else if (![line compare:@"orange" options:1])
    {
        jsonURL = [NSURL URLWithString:@"http://developer.mbta.com/lib/rthr/orange.json"];
    }
    
    //store pure JSON inside data file
    NSData *jsonPure = [NSData dataWithContentsOfURL:jsonURL];
    
    //check if JSON retrieval succeeded
    if (jsonPure == nil)
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setObject:@"Failed to retrieve JSON data. Please check your connection to the Internet." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"searchNavData" code:1 userInfo:errorDetail];
        return nil;
    }
    
    //parse JSON into dictionary of Foundation objects using NSJsonSerialization
    NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonPure
                                                                options:0
                                                                  error:0];
    //check for parse success
    if (jsonPure == nil)
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setObject:@"Failed to parse JSON data." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"searchNavData" code:2 userInfo:errorDetail];
        return nil;
    }
    
    //dive into parsed json dictionary to create array of trip dictionaries
    NSDictionary *triplist = [[jsonObjects objectForKey:@"TripList"]objectForKey:@"Trips"];
    
    //alloc array to store search results
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    //loops to extract nav position info
    for (NSDictionary *trip in triplist)
    {
        
        //init and store nava data in cllocationcoordinate2d struct in mutablearray provided nav data exists
        if ([trip objectForKey:@"Position"]!= nil && ![[trip objectForKey:@"Destination"] compare:destination options:1])
        {
            NSDictionary *navdata = [trip objectForKey:@"Position"];
            [results addObject:navdata];
        }
    }
    
    //return results
    return results;
}


+ (NSArray *) redStations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"red" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    return array;
}

+ (NSArray *) orangeStations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"orange" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    return array;
}

+ (NSArray *) blueStations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"blue" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    return array;
}

+ (NSArray *) greenStations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"green" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    return array;
}

+ (NSArray *) silverStations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"silver" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    return array;
}

+ (NSArray *) redStationsOrdered {
    NSArray *array = [NSArray arrayWithObjects:@"Alewife", @"Davis", @"Porter Square", @"Harvard Square", @"Central Square", @"Kendall/MIT", @"Charles/MGH", @"Park Street", @"Downtown Crossing", @"South Station", @"Broadway", @"Andrew", @"JFK/UMass", @"North Quincy", @"Wollaston", @"Quincy Center", @"Quincy Adams", @"Braintree", @"Savin Hill", @"Fields Corner", @"Shawmut", @"Ashmont", nil];
    
    return array;
}
+ (NSArray *) blueStationsOrdered {
    NSArray *array = [NSArray arrayWithObjects:@"Wonderland", @"Revere Beach", @"Beachmont", @"Suffolk Downs", @"Orient Heights", @"Wood Island", @"Airport", @"Maverick", @"Aquarium", @"State Street", @"Government Center", @"Bowdoin", nil];
    
    return array;
}
+ (NSArray *) orangeStationsOrdered {
    NSArray *array = [NSArray arrayWithObjects:@"Oak Grove", @"Malden Center", @"Wellington", @"Sullvian Square", @"Community College", @"North Station", @"Haymarket", @"State Street", @"Downtown Crossing", @"Chinatown", @"Tufts Medical", @"Back Bay", @"Mass Ave", @"Ruggles", @"Roxbury Crossing", @"Jackson Square", @"Stony Brook", @"Green Street", @"Forest Hills", nil];
    
    return array;
}
@end

//
//  route.m
//  Where's My T
//
//  Created by Jefferson Lee on 1/20/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import "route.h"

@implementation route

@synthesize routes;

- (void)parseXML{
    
    // initialize parser
    NSURL *xmlURL = [NSURL URLWithString:@"http://webservices.nextbus.com/service/publicXMLFeed?command=routeList&a=mbta"];
    NSData *xmlData = [NSData dataWithContentsOfURL:xmlURL];
    parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    // set delegate, then parse
    [parser setDelegate:self];
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"route"])
    {
        if (!routes)
        {
            routes = [[NSMutableArray alloc] init];
        }
        
        NSString *Title = [attributeDict objectForKey:@"title"];
        [routes addObject:Title];
    }
}
@end

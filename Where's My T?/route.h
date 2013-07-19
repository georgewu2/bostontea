//
//  route.h
//  Where's My T
//
//  Created by Jefferson Lee on 1/20/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface route : NSObject <NSXMLParserDelegate>{

    NSXMLParser *parser;
    NSMutableArray *routes;
    
}

@property (nonatomic, retain) NSMutableArray *routes;

-(void)parseXML;

@end

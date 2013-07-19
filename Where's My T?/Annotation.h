//
//  Annotation.h
//  Where's My T
//
//  Created by George Wu on 12/9/12.
//  Copyright (c) 2012 George Wu. All rights reserved.
//
//  Inspired from http://www.youtube.com/watch?v=fvhNHvq9aLQ

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>


@interface Annotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    NSString *title;
    
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@end

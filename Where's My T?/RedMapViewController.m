//
//  RedMapViewController.m
//  Where's My T
//
//  Created by George Wu on 12/6/12.
//  Copyright (c) 2012 George Wu. All rights reserved.
//

#import "RedMapViewController.h"
#import "Annotation.h"
#import "Search.h"


#define METERS_PER_MILE 1690.344


@interface RedMapViewController ()

@end

@implementation RedMapViewController


- (IBAction)refreshClicked:(id)sender
{
    // create mutable array for removing trains
    NSMutableArray *remove = [[NSMutableArray alloc] init];
    
    // add trains to array
    for (Annotation *ann in _mapView.annotations) {
        if ([ann.title isEqualToString:@"train"]) {
            [remove addObject:ann];
        }
    }
    
    // remove train annotations from map
    [_mapView removeAnnotations:remove];
    
    // for error checking
    NSError *error = nil;
    
    // gets latest train locations
    NSMutableArray *trains = [Search searchNavData:@"red" andDestination:[Segment titleForSegmentAtIndex:[Segment selectedSegmentIndex]] andError:&error];
    
    // no errors!
    if (error == nil) {
        // each train
        for (NSDictionary *train in trains) {
            
            // new annotation
            Annotation *point = [[Annotation alloc] init];
            
            // initialize new coordinate
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[train objectForKey:@"Lat"] doubleValue];
            coordinate.longitude = [[train objectForKey:@"Long"] doubleValue];

            // initialize annotation
            point.coordinate = coordinate;
            point.title = @"train";
            
            // add to map
            [_mapView addAnnotation:point];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *train = @"train";
    
    if ([annotation isKindOfClass:[Annotation class]]) {
        
        // try to get unused annotation
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:train];
        // unused annotation not available
        if (!view && ![annotation.title compare:@"train"]) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:train];
            view.image = [UIImage imageNamed:@"redPin.png"];
        }
        return view;
    }
    return nil;
}

- (void)viewDidAppear:(BOOL)animated {
    // make center coordinate
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.311973;
    zoomLocation.longitude = -71.040344;
    
    // set the viewing region to predetermined location, to display all of the red line
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 7 * METERS_PER_MILE, 7 * METERS_PER_MILE);
    
    // zoom to the region without animation
    [_mapView setRegion:viewRegion animated:NO];
    
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    // display polyline
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
    // set polyline color to red
    polylineView.strokeColor = [UIColor redColor];
    
    // set polyline width to 1
    polylineView.lineWidth = 1.0;
    
    return polylineView;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // set self to send messages to me
    [_mapView setDelegate:self];
    
    // create coordinates for each station
    CLLocationCoordinate2D alewife, davis, porter, harvard, central, kendall, charles, park, downtown, south, broadway, andrew, jfk, northQuincy, wollaston, quincyCenter, quincyAdams, braintree, savin, fields, shawmut, ashmont;
    
    // set their latitudes and longitudes
    alewife.latitude = 42.396147, alewife.longitude = -71.142091;
    davis.latitude = 42.396740, davis.longitude = -71.121815;
    porter.latitude = 42.388307, porter.longitude = -71.119121;
    harvard.latitude = 42.373494, harvard.longitude = -71.119008;
    central.latitude = 42.365467, central.longitude = -71.103842;
    kendall.latitude = 42.362452, kendall.longitude = -71.086124;
    charles.latitude = 42.36113, charles.longitude = -71.070798;
    park.latitude = 42.356276, park.longitude = -71.062274;
    downtown.latitude = 42.355341, downtown.longitude = -71.060348;
    south.latitude = 42.352431, south.longitude = -71.054994;
    broadway.latitude = 42.342432, broadway.longitude = -71.057124;
    andrew.latitude = 42.329965, andrew.longitude = -71.056952;
    jfk.latitude = 42.320510, jfk.longitude = -71.052489;
    northQuincy.latitude = 42.274927, northQuincy.longitude = -71.030087;
    wollaston.latitude = 42.266353, wollaston.longitude = -71.020260;
    quincyCenter.latitude = 42.251647, quincyCenter.longitude = -71.005797;
    quincyAdams.latitude = 42.233157, quincyAdams.longitude = -71.007042;
    braintree.latitude = 42.207954, braintree.longitude = -71.001334;
    savin.latitude = 42.311236, savin.longitude = -71.052983;
    fields.latitude = 42.300119, fields.longitude = -71.061673;
    shawmut.latitude = 42.293072, shawmut.longitude = -71.065750;
    ashmont.latitude = 42.284643, ashmont.longitude = -71.063883;
    
    // create an array of coordinates
    CLLocationCoordinate2D points[] = {alewife, davis, porter, harvard, central, kendall, charles, park, downtown, south, broadway, andrew, jfk, northQuincy, wollaston, quincyCenter, quincyAdams, braintree};
    
    // create the other branch
    CLLocationCoordinate2D points2[] = {jfk, savin, fields, shawmut, ashmont};

    // make the polylines
    MKPolyline *route = [MKPolyline polylineWithCoordinates:points count:18];
    MKPolyline *route2 = [MKPolyline polylineWithCoordinates:points2 count:5];
    
    // add polylines to overlay
    [_mapView addOverlay:route];
    [_mapView addOverlay:route2];
    
    // gets array of stations
    NSArray *stations = [Search redStations];
    
    // creates annotations for first branch
    for (int i = 0; i < 18; i++) {
        Annotation *point = [[Annotation alloc] init];
        point.title = [stations objectAtIndex:i];
        point.coordinate = points[i];
        
        // add to map
        [_mapView addAnnotation:point];
    }
    
    
    // creates annotations for second branch
    for (int i = 1; i < 5; i++) {
        Annotation *point = [[Annotation alloc] init];
        point.title = [stations objectAtIndex:(i + 17)];
        point.coordinate = points2[i];
        
        // add to map
        [_mapView addAnnotation:point];
    }

    // for error checking
    NSError *error = nil;
    
    // gets latest trains
    NSMutableArray *trains = [Search searchNavData:@"red" andDestination:[Segment titleForSegmentAtIndex:[Segment selectedSegmentIndex]] andError:&error];
    
    // no errors
    if (error == nil) {
        
        // each train
        for (NSDictionary *train in trains) {
            
            // make new annotation
            Annotation *point = [[Annotation alloc] init];
            
            // initialize new coordinate
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[train objectForKey:@"Lat"] doubleValue];
            coordinate.longitude = [[train objectForKey:@"Long"] doubleValue];
            
            // initialize annotation
            point.coordinate = coordinate;
            point.title = @"train";
            
            // add to map
            [_mapView addAnnotation:point];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

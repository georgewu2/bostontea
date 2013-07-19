//
//  OrangeMapViewController.m
//  Where's My T
//
//  Created by George Wu on 12/8/12.
//  Copyright (c) 2012 George Wu. All rights reserved.
//

#import "OrangeMapViewController.h"
#import "Annotation.h"
#import "Search.h"


#define METERS_PER_MILE 1690.344

@interface OrangeMapViewController ()

@end

@implementation OrangeMapViewController


- (IBAction)refreshClicked:(id)sender {
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
    NSMutableArray *trains = [Search searchNavData:@"orange" andDestination:[Segment titleForSegmentAtIndex:[Segment selectedSegmentIndex]] andError:&error];
    
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
            view.image = [UIImage imageNamed:@"orangePin.png"];
        }
        return view;
    }
    return nil;
}


- (void)viewDidAppear:(BOOL)animated {
    // make center coordinate
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.3607;
    zoomLocation.longitude = -71.074162;
    
    // set the viewing region to predetermined location, to display all of the orange line
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 6 * METERS_PER_MILE, 6 * METERS_PER_MILE);
    
    // zoom to the region without animation
    [_mapView setRegion:viewRegion animated:NO];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    // display polyline
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
    // set polyline color to orange
    polylineView.strokeColor = [UIColor orangeColor];
    
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
    
    // create coordinates for all stations
    CLLocationCoordinate2D oak, malden, wellington, sullivan, communityCollege, north, haymarket, state, dtownCrossing, chinatown, tufts, backBay, massAve, ruggles, roxbury, jackson, stonybrook, green, forestHills;
    
    // set latitudes and longitudes for each coordinate
    oak.latitude = 42.436737, oak.longitude = -71.071034;
    malden.latitude = 42.426783, malden.longitude = -71.074285;
    wellington.latitude = 42.402374, wellington.longitude = -71.077150;
    sullivan.latitude = 42.383958, sullivan.longitude = -71.077131;
    communityCollege.latitude = 42.372979, communityCollege.longitude = -71.069934;
    north.latitude = 42.365599, north.longitude = -71.061888;
    haymarket.latitude = 42.362904, haymarket.longitude = -71.058412;
    state.latitude = 42.358909, state.longitude = -71.057789;
    dtownCrossing.latitude = 42.355452, dtownCrossing.longitude = -71.060321;
    chinatown.latitude = 42.352439, chinatown.longitude = -71.062896;
    tufts.latitude = 42.349537, tufts.longitude = -71.063776;
    backBay.latitude = 42.347238, backBay.longitude = -71.075470;
    massAve.latitude = 42.341401, massAve.longitude = -71.083388;
    ruggles.latitude = 42.336580, ruggles.longitude = -71.089268;
    roxbury.latitude = 42.331488, roxbury.longitude = -71.095340;
    jackson.latitude = 42.323223, jackson.longitude = -71.099739;
    stonybrook.latitude = 42.317289, stonybrook.longitude = -71.104202;
    green.latitude = 42.310561, green.longitude = -71.107314;
    forestHills.latitude = 42.300643, forestHills.longitude = -71.114159;
    
    // create array of coordinates
    CLLocationCoordinate2D points[] = {oak, malden, wellington, sullivan, communityCollege, north, haymarket, state, dtownCrossing, chinatown, tufts, backBay, massAve, ruggles, roxbury, jackson, stonybrook, green, forestHills};
    
    // make a polyline using array of coordinates
    MKPolyline *route = [MKPolyline polylineWithCoordinates:points count:19];
    
    // add polyline to overlay
    [_mapView addOverlay:route];
    
    // get stations in order
    NSArray *stations = [Search orangeStations];
    
    for (int i = 0; i < 19; i++) {
        // create and initialize annotation
        Annotation *point = [[Annotation alloc] init];
        point.title = [stations objectAtIndex:i];
        point.coordinate = points[i];
        
        // add to map
        [_mapView addAnnotation:point];
    }
    
    // for error checking
    NSError *error = nil;
    
    // gets latest trains
    NSMutableArray *trains = [Search searchNavData:@"orange" andDestination:[Segment titleForSegmentAtIndex:[Segment selectedSegmentIndex]] andError:&error];
    
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

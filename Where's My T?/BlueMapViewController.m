//
//  BlueMapViewController.m
//  Where's My T
//
//  Created by George Wu on 12/8/12.
//  Copyright (c) 2012 George Wu. All rights reserved.
//

#import "BlueMapViewController.h"
#import "Annotation.h"
#import "Search.h"

#define METERS_PER_MILE 1690.344

@interface BlueMapViewController ()

@end

@implementation BlueMapViewController


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
    NSMutableArray *trains = [Search searchNavData:@"blue" andDestination:[Segment titleForSegmentAtIndex:[Segment selectedSegmentIndex]] andError:&error];
    
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
            view.image = [UIImage imageNamed:@"bluePin.png"];
        }
        return view;
    }
    return nil;
}


- (void)viewDidAppear:(BOOL)animated {
    // make center coordinate
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.380041;
    zoomLocation.longitude = -71.019316;
    
    // set the viewing region to predetermined location, to display all of the blue line
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 4 * METERS_PER_MILE, 4 * METERS_PER_MILE);
    
    // zoom to the region without animation
    [_mapView setRegion:viewRegion animated:NO];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    // display overlay
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
    // set polyline color to blue
    polylineView.strokeColor = [UIColor blueColor];
    
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
    CLLocationCoordinate2D wonderland, revereBeach, beachmont, suffolk, orient, wood, airport, maverick, aquarium, state, government, bowdoin;
    
    // set latitudes and longitudes for each coordinate
    wonderland.latitude = 42.413445, wonderland.longitude = -70.991721;
    revereBeach.latitude = 42.407829, revereBeach.longitude = -70.992547;
    beachmont.latitude = 42.397530, beachmont.longitude = -70.992343;
    suffolk.latitude = 42.390494, suffolk.longitude = -70.997139;
    orient.latitude = 42.386848, orient.longitude = -71.004660;
    wood.latitude = 42.379661, wood.longitude = -71.022813;
    airport.latitude = 42.374231, airport.longitude = -71.030506;
    maverick.latitude = 42.368953, maverick.longitude = -71.039625;
    aquarium.latitude = 42.360145, aquarium.longitude = -71.048316;
    state.latitude = 42.358909, state.longitude = -71.057789;
    government.latitude = 42.359321, government.longitude = -71.059549;
    bowdoin.latitude = 42.361160, bowdoin.longitude = -71.062102;
    
    // create of array of coordinates
    CLLocationCoordinate2D points[] = {wonderland, revereBeach, beachmont, suffolk, orient, wood, airport, maverick, aquarium, state, government, bowdoin};
    
    // make polyline using array of coordinates
    MKPolyline *route = [MKPolyline polylineWithCoordinates:points count:12];
    
    // add polyline to overlay
    [_mapView addOverlay:route];
    
    // get blue stations ordered
    NSArray *stations = [Search blueStations];
    
    for (int i = 0; i < 12; i++) {
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
    NSMutableArray *trains = [Search searchNavData:@"blue" andDestination:[Segment titleForSegmentAtIndex:[Segment selectedSegmentIndex]] andError:&error];
    
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

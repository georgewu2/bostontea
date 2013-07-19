//
//  BlueMapViewController.h
//  Where's My T
//
//  Created by George Wu on 12/8/12.
//  Copyright (c) 2012 George Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BlueMapViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet UISegmentedControl *Segment;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)refreshClicked:(id)sender;

@end

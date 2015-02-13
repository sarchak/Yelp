//
//  MapViewController.m
//  Yelp
//
//  Created by Shrikar Archak on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37.774866, -122.394556);
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(coordinate, 2500, 2500);
    [self.mapView setRegion:reg animated:YES];
    self.mapView.showsUserLocation = true;
    
    for(NSDictionary *data in self.businesses){
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        NSDictionary *location = [data valueForKeyPath:@"location.coordinate"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([location[@"latitude"] doubleValue],[location[@"longitude"] doubleValue]);
        annotation.coordinate = coordinate;
        NSArray *address = [data valueForKeyPath:@"location.display_address"];
        annotation.title = data[@"name"];
        annotation.subtitle = [address componentsJoinedByString:@", "];
        [self.mapView addAnnotation:annotation];
    }
    self.title = @"MapView";
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
}

-(void) goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MapCell.h
//  Yelp
//
//  Created by Shrikar Archak on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
@interface MapCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

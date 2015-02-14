//
//  Business.h
//  Yelp
//
//  Created by Shrikar Archak on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//
#import "MapKit/MapKit.h"
@interface Business : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *reviews;
@property (nonatomic,strong) NSString *distance;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSURL *ratingsUrl;
@property (nonatomic,strong) NSURL *businessImageUrl;
@property (nonatomic,strong) NSString *categories;
@property (nonatomic,assign) BOOL dealsOn;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

+(Business*) getBusiness: (NSDictionary*) data;
@end
//
//  Business.m
//  Yelp
//
//  Created by Shrikar Archak on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Business.h"

@implementation Business

+(Business*) getBusiness:(NSDictionary*) data {
    Business *business = [[Business alloc] init];
    business.name = [NSString stringWithFormat:@"%@", data[@"name"]];
    
    business.businessImageUrl = [NSURL URLWithString:data[@"image_url"]];
    business.ratingsUrl = [NSURL URLWithString:data[@"rating_img_url"]];
    business.reviews = [NSString stringWithFormat:@"%@ reviews", data[@"review_count"]];
    NSDictionary *location = data[@"location"];
    NSString *distanceString = data[@"distance"];
    double distance = 0.000621371192 * distanceString.doubleValue;
    business.distance = [NSString stringWithFormat:@"%.2f mi", distance];
    business.dealsOn = (data[@"deals"] != nil);
    
    if(location[@"neighborhoods"][0]) {
        business.address = [NSString stringWithFormat:@"%@, %@", location[@"display_address"][0],location[@"neighborhoods"][0]];
    } else {
        business.address = [NSString stringWithFormat:@"%@", location[@"display_address"][0]];
    }
    
    
    
    NSMutableArray *categories = [NSMutableArray array];
    for(NSArray *category in data[@"categories"]){
        [categories addObject:category[0]];
    }
    business.categories = [categories componentsJoinedByString:@","];
    
    location = [data valueForKeyPath:@"location.coordinate"];
    business.coordinate = CLLocationCoordinate2DMake([location[@"latitude"] doubleValue],[location[@"longitude"] doubleValue]);

    return business;
}

@end
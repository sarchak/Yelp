//
//  DetailCell.h
//  Yelp
//
//  Created by Shrikar Archak on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *reviews;
@property (weak, nonatomic) IBOutlet UILabel *cuisine;
@property (weak, nonatomic) IBOutlet UILabel *timings;
@property (weak, nonatomic) IBOutlet UIImageView *ratingsView;

@end

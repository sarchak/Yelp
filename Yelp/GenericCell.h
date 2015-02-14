//
//  GenericCell.h
//  Yelp
//
//  Created by Shrikar Archak on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;

@end

//
//  DetailViewController.h
//  Yelp
//
//  Created by Shrikar Archak on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
@interface DetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) Business* business;
@end

//
//  FiltersViewController.h
//  Yelp
//
//  Created by Shrikar Archak on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealCell.h"
#import "CategoryCell.h"

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

-(void) filtersViewController: (FiltersViewController*) filtersViewController didChangeFilters: (NSDictionary*) filters;

@end
@interface FiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DealCellDelegate, CategoryCellDelegate>
@property (weak,nonatomic) id<FiltersViewControllerDelegate> delegate;
@end

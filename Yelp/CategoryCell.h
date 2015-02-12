//
//  CategoryCell.h
//  Yelp
//
//  Created by Shrikar Archak on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryCell;

@protocol CategoryCellDelegate <NSObject>

-(void) categoryCell: (CategoryCell*) categoryCell didChangeValue: (BOOL) value;

@end

@interface CategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (nonatomic, assign) BOOL on;
@property (weak, nonatomic) id<CategoryCellDelegate> delegate;


-(void) setOn:(BOOL)on animated:(BOOL) animated;
@end

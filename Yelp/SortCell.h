//
//  SortCell.h
//  Yelp
//
//  Created by Shrikar Archak on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SortCell;

@protocol SortCellDelegate <NSObject>

-(void) sortCell: (SortCell*)sortCell didChangeValue:(NSInteger) value;

@end

@interface SortCell : UITableViewCell
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic,weak) id<SortCellDelegate> delegate;
-(void) setSelectedIndex:(NSInteger)selectedIndex;
@end

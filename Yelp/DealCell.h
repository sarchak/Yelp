//
//  DealCell.h
//  Yelp
//
//  Created by Shrikar Archak on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DealCell;

@protocol DealCellDelegate <NSObject>
-(void) dealCell: (DealCell*) dealCell didChangeValue:(BOOL) value;
@end


@interface DealCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, weak) id<DealCellDelegate> delegate;
@end


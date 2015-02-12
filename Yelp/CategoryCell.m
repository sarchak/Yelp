//
//  CategoryCell.m
//  Yelp
//
//  Created by Shrikar Archak on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "CategoryCell.h"

@interface CategoryCell()
    @property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@end

@implementation CategoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate categoryCell:self didChangeValue:self.toggleSwitch.on];
}

-(void) setOn:(BOOL)on {
    [self setOn:on animated:NO];
    self.toggleSwitch.on = on;
}
-(void) setOn:(BOOL)on animated:(BOOL)animated {
    [self.toggleSwitch setOn:on animated:animated];
}
@end

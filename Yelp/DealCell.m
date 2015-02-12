//
//  DealCell.m
//  Yelp
//
//  Created by Shrikar Archak on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DealCell.h"

@implementation DealCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate dealCell:self didChangeValue:self.toggleSwitch.on];
}

@end

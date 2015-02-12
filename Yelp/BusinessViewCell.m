//
//  BusinessViewCell.m
//  Yelp
//
//  Created by Shrikar Archak on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessViewCell.h"

@implementation BusinessViewCell

- (void)awakeFromNib {
    // Initialization code
    self.name.preferredMaxLayoutWidth = self.name.frame.size.width;
    self.posterImageView.layer.cornerRadius = 2.0;
    self.posterImageView.clipsToBounds = YES;
    self.dealImage.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews {
    [super layoutSubviews];
    self.name.preferredMaxLayoutWidth = self.name.frame.size.width;
    
}

@end

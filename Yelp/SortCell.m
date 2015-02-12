//
//  SortCell.m
//  Yelp
//
//  Created by Shrikar Archak on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SortCell.h"

@interface SortCell()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
@implementation SortCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)valueChanged:(id)sender {
    NSLog(@"Value changed to : %ld", self.segmentedControl.selectedSegmentIndex);
    [self.delegate sortCell:self didChangeValue:self.segmentedControl.selectedSegmentIndex];
}

-(void) setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    self.segmentedControl.selectedSegmentIndex = selectedIndex;
}
@end

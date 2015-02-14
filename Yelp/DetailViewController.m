//
//  DetailViewController.m
//  Yelp
//
//  Created by Shrikar Archak on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailCell.h"
#import "MapCell.h"
#import "GenericCell.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"DetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MapCell" bundle:nil] forCellReuseIdentifier:@"MapCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GenericCell" bundle:nil] forCellReuseIdentifier:@"GenericCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 220;
    NSLog(@"%@", self.business);
    self.title = self.business.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Restaurant Details";
    }
    return nil;
}

-(UITableViewCell*) getTableViewCell:(NSIndexPath *) indexPath {
    UITableViewCell *cell = nil;
    NSLog(@"%@", indexPath);

    if(indexPath.section == 0){
        if(indexPath.row == 0){
            DetailCell *dcell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
            dcell.restaurantName.text = self.business.name;
            [dcell.ratingsView setImageWithURL:self.business.ratingsUrl];
            dcell.reviews.text = self.business.reviews;
            dcell.distance.text = self.business.distance;
            dcell.cuisine.text = self.business.categories;
            cell = dcell;
        }
    } else if (indexPath.section == 1){
        if(indexPath.row == 0){
            MapCell *mcell = [self.tableView dequeueReusableCellWithIdentifier:@"MapCell"];
            MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(self.business.coordinate, 500, 500);
            [mcell.mapView setRegion:reg animated:YES];
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = self.business.coordinate;
            
            annotation.title = self.business.name;
            annotation.subtitle = self.business.address;
            [mcell.mapView addAnnotation:annotation];
            
            cell = mcell;
        } else if (indexPath.section == 1){
            GenericCell *gcell = [self.tableView dequeueReusableCellWithIdentifier:@"GenericCell"];
            gcell.titleLabel.text = @"Directions";
            gcell.secondaryLabel.text = self.business.address;
            cell = gcell;
        }
    }


    return cell;
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    } else if (section == 1){
        return 2;
    }
    return 1;
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self getTableViewCell:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

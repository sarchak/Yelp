//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "BusinessViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *businesses;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self.client searchWithTerm:@"Restaurants" params:nil success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"response: %@", response);
            NSDictionary *data = response;
            self.businesses = data[@"businesses"];
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Yelp";
    /* Setup datasource and delegate */
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView registerNib:[UINib  nibWithNibName:@"BusinessViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 85;
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];

}

-(void) onFilter {
    FiltersViewController *fvc = [[FiltersViewController alloc] init];
    fvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nvc animated:true completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"] ;
    NSDictionary *data = self.businesses[indexPath.row];
    cell.name.text = data[@"name"];
    
    [cell.posterImageView setImageWithURL:[NSURL URLWithString:data[@"image_url"]]];
    [cell.ratingsImageView setImageWithURL:[NSURL URLWithString:data[@"rating_img_url"]]];
    cell.reviews.text = [NSString stringWithFormat:@"%@ reviews", data[@"review_count"]];
    NSDictionary *location = data[@"location"];
    NSString *distanceString = data[@"distance"];
    double distance = 0.000621371192 * distanceString.doubleValue;
    cell.distance.text = [NSString stringWithFormat:@"%.2f mi", distance];
    cell.address.text = location[@"display_address"][0];
    
    NSMutableArray *categories = [NSMutableArray array];
    for(NSArray *category in data[@"categories"]){
        [categories addObject:category[0]];
    }
    cell.categories.text = [categories componentsJoinedByString:@","];
    return cell;
}

-(void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"Filters Changed : %@", filters);
    [self.client searchWithTerm:@"Restaurants" params:filters success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSDictionary *data = response;
        self.businesses = data[@"businesses"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}
@end

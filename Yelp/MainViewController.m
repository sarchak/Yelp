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
@property (strong, nonatomic) UISearchBar *customSearchBar;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        [self fetchBusinesses:@"Restaurants" params:nil];
    }
    return self;
}

-(void) fetchBusinesses: (NSString*) query params: (NSDictionary*) params {
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSDictionary *data = response;
        self.businesses = data[@"businesses"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
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
    self.customSearchBar = [[UISearchBar alloc] init];
    self.customSearchBar.showsCancelButton = YES;
    self.customSearchBar.placeholder = @"Search";
    self.customSearchBar.delegate = self;
//    self.customSearchBar.tintColor = [UIColor colorWithRed:181.0/255 green:10.0/255 blue:4.0/255 alpha:1];
    self.navigationItem.titleView = self.customSearchBar;
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
    cell.name.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row + 1, data[@"name"]];
    
    [cell.posterImageView setImageWithURL:[NSURL URLWithString:data[@"image_url"]]];
    [cell.ratingsImageView setImageWithURL:[NSURL URLWithString:data[@"rating_img_url"]]];
    cell.reviews.text = [NSString stringWithFormat:@"%@ reviews", data[@"review_count"]];
    NSDictionary *location = data[@"location"];
    NSString *distanceString = data[@"distance"];
    double distance = 0.000621371192 * distanceString.doubleValue;
    cell.distance.text = [NSString stringWithFormat:@"%.2f mi", distance];
    
//    NSMutableString *tmp = location[@"display_address"][0];
//    if(location[@"neighborhoods"]){
//        [tmp appendString:location[@"neighborhoods"][0]];
//    }
    if(location[@"neighborhoods"][0]) {
        cell.address.text = [NSString stringWithFormat:@"%@, %@", location[@"display_address"][0],location[@"neighborhoods"][0]];
    } else {
        cell.address.text = [NSString stringWithFormat:@"%@", location[@"display_address"][0]];
    }

    
    
    NSMutableArray *categories = [NSMutableArray array];
    for(NSArray *category in data[@"categories"]){
        [categories addObject:category[0]];
    }
    cell.categories.text = [categories componentsJoinedByString:@","];
    return cell;
}

-(void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"Filters Changed : %@", filters);
    [self fetchBusinesses:@"Restaurants" params:filters];
}


-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    self.active = YES;
//    if([searchText isEqual:@""]){
//        self.active = NO;
//        [self.tableView reloadData];
//    }
//    [self searchFunc:searchText];
    NSLog(@"searching");
}
//
//
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    self.customSearchBar.text = nil;
    self.customSearchBar.placeholder = @"Search";
    [self.customSearchBar resignFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Text search endded");
    [self fetchBusinesses:searchBar.text params:nil];
    [self.customSearchBar resignFirstResponder];
}
@end

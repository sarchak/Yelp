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
#import "SVProgressHUD.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "MapViewController.h"
#import "DetailViewController.h"
#import "Business.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *businesses;
@property (strong, nonatomic) UISearchBar *customSearchBar;
@property (assign, nonatomic) BOOL filterReset;
@property (strong, nonatomic) NSDictionary *filters;
@property (assign, nonatomic) NSInteger offset;
@property (strong, nonatomic) NSString *searchText;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
    }
    return self;
}

-(void) fetchBusinesses: (NSString*) query params: (NSDictionary*) params {
    [SVProgressHUD show];
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSDictionary *data = response;
        if(self.businesses.count == 0 || self.filterReset){
          self.businesses = data[@"businesses"];
            self.filterReset = NO;
            self.offset = self.offset + self.businesses.count;
        } else {
            NSArray* recent= data[@"businesses"];
            NSMutableArray *tmpArray = [self.businesses mutableCopy];
            [tmpArray addObjectsFromArray:recent];
            self.businesses = tmpArray;
            self.offset = self.offset + recent.count;
            
        }
        NSLog(@"Offset : %ld", self.offset);
        [self.filters setValue: [NSNumber numberWithInteger:self.offset] forKey:@"offset"];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        [SVProgressHUD dismiss];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchText = nil;
    self.offset = 0;
    self.title = @"Yelp";
    /* Setup datasource and delegate */
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView registerNib:[UINib  nibWithNibName:@"BusinessViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 85;
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapViewClicked)];
    self.customSearchBar = [[UISearchBar alloc] init];
//    self.customSearchBar.showsCancelButton = YES;
    self.customSearchBar.placeholder = @"Search";
    self.customSearchBar.delegate = self;
//    self.customSearchBar.tintColor = [UIColor colorWithRed:181.0/255 green:10.0/255 blue:4.0/255 alpha:1];
    self.navigationItem.titleView = self.customSearchBar;

    [SVProgressHUD setForegroundColor: [UIColor colorWithRed:181.0/255 green:10.0/255 blue:4.0/255 alpha:1]];

    [self fetchBusinesses:nil params:self.filters];
    
    /* Infinite scrolling */
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"Offset : %@", self.filters);
        NSLog(@"Offset : %@", self.searchText);
        [self fetchBusinesses:self.searchText params:self.filters];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

-(void) onFilter {
    FiltersViewController *fvc = [[FiltersViewController alloc] init];
    fvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nvc animated:true completion:nil];
}

-(void) mapViewClicked {
    MapViewController *mvc = [[MapViewController alloc] init];
    mvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    mvc.businesses = self.businesses;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:mvc];
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
    cell.dealImage.hidden= YES;
    NSDictionary *data = self.businesses[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row + 1, data[@"name"]];
    
    [cell.posterImageView setImageWithURL:[NSURL URLWithString:data[@"image_url"]]];
    [cell.ratingsImageView setImageWithURL:[NSURL URLWithString:data[@"rating_img_url"]]];
    cell.reviews.text = [NSString stringWithFormat:@"%@ reviews", data[@"review_count"]];
    NSDictionary *location = data[@"location"];
    NSString *distanceString = data[@"distance"];
    double distance = 0.000621371192 * distanceString.doubleValue;
    cell.distance.text = [NSString stringWithFormat:@"%.2f mi", distance];

    if(data[@"deals"] != nil){
        cell.dealImage.hidden= NO;
    }
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"Filters Changed : %@", filters);
    self.filterReset = YES;
    self.offset = 0;
    self.filters = filters;
    [self fetchBusinesses:nil params:filters];
}


-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
        NSLog(@"Begin editing");
}
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if([self.searchText  isEqual: @""] || self.searchText == nil) {
//        NSLog(@"Coming in the toggle");
//        self.customSearchBar.text = nil;
//        self.customSearchBar.placeholder = @"Search";
//        [self.customSearchBar resignFirstResponder];
//    }

}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchText = nil;
    self.customSearchBar.text = nil;
    self.customSearchBar.placeholder = @"Search";
    [self.customSearchBar resignFirstResponder];
    NSLog(@"Text search cancel clicked endded");
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"Text did end endded");
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Text search endded");
    self.filterReset = YES;
    self.offset = 0;
    self.searchText = searchBar.text;
    [self fetchBusinesses:searchBar.text params:nil];
    [self.customSearchBar resignFirstResponder];
    self.customSearchBar.text = nil;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *dvc = [[DetailViewController alloc] init];
    NSDictionary *data = self.businesses[indexPath.row];
    dvc.business = [Business getBusiness:data];

    [self.navigationController pushViewController:dvc animated:YES];
}
@end

//
//  FiltersViewController.m
//  Yelp
//
//  Created by Shrikar Archak on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "CategoryCell.h"

@interface FiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *simpleCategories;
@property (strong, nonatomic) NSArray *distanceOptions;
@property (strong, nonatomic) NSArray *sortOptions;
@property (strong, readonly) NSDictionary* filters;
@property (nonatomic, assign) BOOL dealsOn;
@property (nonatomic, assign) BOOL listView;
@property (nonatomic, strong) NSMutableSet* categoryFilters;
@property (nonatomic, strong) NSUserDefaults* userDefaults;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, assign) NSInteger sortIndex;
-(UITableViewCell*) getTableViewCell:(NSIndexPath*) indexPath;


@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.categories = [self getPopularCategories];
    self.simpleCategories = @[@"American",@"Thai",@"Chinese",@"Indian", @"Show All"];
    self.distanceOptions = @[@"Best Match", @"0.3",@"1", @"5", @"20"];
    self.sortOptions = @[@"Best Match",@"Distance", @"Rating"];
    /* Register nibs */
    [self.tableView registerNib:[UINib nibWithNibName:@"DealCell" bundle:nil] forCellReuseIdentifier:@"DealCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DistanceCell" bundle:nil] forCellReuseIdentifier:@"DistanceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SortCell" bundle:nil] forCellReuseIdentifier:@"SortCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellReuseIdentifier:@"CategoryCell"];
    
    self.categoryFilters = [NSMutableSet set];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.dealsOn = [self.userDefaults boolForKey:@"deals_filter"];
    self.selectedIndex = [self.userDefaults integerForKey:@"selected"];
    self.radius = [self.userDefaults integerForKey:@"radius"];
    self.sortIndex = [self.userDefaults integerForKey:@"sort"];
    [self.categoryFilters addObjectsFromArray:[self.userDefaults arrayForKey:@"categories_filter"]];

}


-(NSDictionary*) filters {
    NSDictionary *filters =[NSMutableDictionary dictionary];
    if(self.categoryFilters.count > 0){
        NSMutableArray *names = [NSMutableArray array];
        for(NSDictionary *curr in self.categoryFilters){
            [names addObject:curr[@"code"]];
        }
        NSString *cFilters = [names componentsJoinedByString: @","];
        [filters setValue:cFilters forKey:@"category_filter"];
    }
    if(self.dealsOn) {
        [filters setValue:[NSNumber numberWithBool:self.dealsOn] forKey:@"deals_filter"];
    }
    if(self.radius > 0){
        [filters setValue:[NSNumber numberWithInteger:self.radius] forKey:@"radius_filter"];
    }
    
    if(self.sortIndex > 0){
        [filters setValue:[NSNumber numberWithInteger:self.sortIndex] forKey:@"sort"];
    }
    
    return filters;
}

-(void) search {
    NSLog(@"Search clicked");

    [self.userDefaults setBool:self.dealsOn forKey:@"deals_filter"];
    [self.userDefaults setObject: [self.categoryFilters allObjects] forKey:@"categories_filter"];
    [self.userDefaults synchronize];
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) cancel {
    NSLog(@"Cancel clicked");
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Most Popular";
    } else if(section == 1){
        return @"Distance";
    } else if(section == 2) {
        return @"Sort By";
    } else {
        return @"Categories";
    }
    return nil;
}



-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 1) {
        if(self.listView){
            return self.distanceOptions.count;
        } else {
            return 1;
        }
    }
    if(section == 3){
        return self.categories.count;
    }
    return 1;
}

-(UITableViewCell*) getTableViewCell:(NSIndexPath *) indexPath {
    UITableViewCell *cell = nil;
    if(indexPath.section == 0) {
        DealCell *dcell = [self.tableView dequeueReusableCellWithIdentifier:@"DealCell"];
        dcell.on = self.dealsOn;
        dcell.delegate = self;
        cell = dcell;

    } else if(indexPath.section == 1){
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"DistanceCell"];
        
        if(self.listView){
            if(indexPath.row == 0){
                cell.textLabel.text = self.distanceOptions[indexPath.row];
            } else if(indexPath.row == 2){
                cell.textLabel.text = [NSString stringWithFormat:@"%@ mile", self.distanceOptions[indexPath.row]];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ miles", self.distanceOptions[indexPath.row]];
            }

            if(indexPath.row == self.selectedIndex){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            if(self.selectedIndex == 0){
                cell.textLabel.text = self.distanceOptions[self.selectedIndex];
            } else if(self.selectedIndex == 2){
                cell.textLabel.text = [NSString stringWithFormat:@"%@ mile", self.distanceOptions[self.selectedIndex]];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ miles", self.distanceOptions[self.selectedIndex]];
            }

            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

    } else if(indexPath.section == 2){
        SortCell *scell = [self.tableView dequeueReusableCellWithIdentifier:@"SortCell"];
        scell.selectedIndex = self.sortIndex;
        scell.delegate = self;
        cell = scell;
    } else {
        CategoryCell *cCell = [self.tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
        cCell.categoryLabel.text = [self.categories[indexPath.row] objectForKey:@"name"];
        cCell.on = [self.categoryFilters containsObject:self.categories[indexPath.row]];
        cCell.delegate = self;
        cCell.posterView.image = [UIImage imageNamed:[self.categories[indexPath.row] objectForKey:@"image"]];
        cell = cCell;
    }

    return cell;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self getTableViewCell:indexPath];
    
    return cell;
}


-(void) dealCell:(DealCell *)dealCell didChangeValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:dealCell];
    NSLog(@"Valued changed to :%ld for section %ld row %ld", value, indexPath.section, indexPath.row);
    self.dealsOn = value;
}

-(void) categoryCell:(CategoryCell *)categoryCell didChangeValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:categoryCell];
    NSLog(@"Valued changed to :%ld for section %ld row %ld", value, indexPath.section, indexPath.row);
    if(value) {
        [self.categoryFilters addObject:self.categories[indexPath.row]];
    } else {
        [self.categoryFilters removeObject:self.categories[indexPath.row]];
    }
}

-(void) sortCell:(SortCell *)sortCell didChangeValue:(NSInteger)value{
    [self.userDefaults setInteger:value forKey:@"sort"];
    self.sortIndex = value;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        if (indexPath.row == 0){
            self.radius = 0;
            NSLog(@"Radius Filter set : %ld", self.radius);
        } else {
            self.radius = [self.distanceOptions[indexPath.row] doubleValue] * 1600;
            NSLog(@"Radius Filter set : %ld", self.radius);
        }
        [self.userDefaults setInteger:self.radius forKey:@"radius"];
        [self.userDefaults setInteger:indexPath.row forKey:@"selected"];
        [self.userDefaults synchronize];
        self.listView = !self.listView;
        self.selectedIndex = indexPath.row;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(NSArray*) getPopularCategories {
    NSArray *categories = @[
                            @{@"name" : @"Restaurants", @"code": @"restaurants", @"image": @"restaurants" },
                            @{@"name" : @"Delivery", @"code": @"fooddeliveryservices" , @"image": @"delivery"},
                            @{@"name" : @"Bars", @"code": @"bars" , @"image":@"bars"},
                            @{@"name" : @"NightLife", @"code": @"nightlife" , @"image":@"bars"},
                            @{@"name" : @"Coffee & Tea", @"code": @"coffee" , @"image":@"coffee"},
                            @{@"name" : @"Gas & Service Station", @"code": @"servicesstations" , @"image": @"gas"},
                            @{@"name" : @"Drugstore", @"code": @"drugstore" , @"image":@"drugstore"},
                            @{@"name" : @"Shopping", @"code": @"shopping", @"image":@"shopping" }
                           ];
    return categories;
}
-(NSArray*) getCategories {
    
    NSArray *categories = @[@{@"name" : @"Afghan", @"code": @"afghani" },
                            @{@"name" : @"African", @"code": @"african" },
                            @{@"name" : @"American, New", @"code": @"newamerican" },
                            @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                            @{@"name" : @"Arabian", @"code": @"arabian" },
                            @{@"name" : @"Argentine", @"code": @"argentine" },
                            @{@"name" : @"Armenian", @"code": @"armenian" },
                            @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
                            @{@"name" : @"Asturian", @"code": @"asturian" },
                            @{@"name" : @"Australian", @"code": @"australian" },
                            @{@"name" : @"Austrian", @"code": @"austrian" },
                            @{@"name" : @"Baguettes", @"code": @"baguettes" },
                            @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
                            @{@"name" : @"Barbeque", @"code": @"bbq" },
                            @{@"name" : @"Basque", @"code": @"basque" },
                            @{@"name" : @"Bavarian", @"code": @"bavarian" },
                            @{@"name" : @"Beer Garden", @"code": @"beergarden" },
                            @{@"name" : @"Beer Hall", @"code": @"beerhall" },
                            @{@"name" : @"Beisl", @"code": @"beisl" },
                            @{@"name" : @"Belgian", @"code": @"belgian" },
                            @{@"name" : @"Bistros", @"code": @"bistros" },
                            @{@"name" : @"Black Sea", @"code": @"blacksea" },
                            @{@"name" : @"Brasseries", @"code": @"brasseries" },
                            @{@"name" : @"Brazilian", @"code": @"brazilian" },
                            @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
                            @{@"name" : @"British", @"code": @"british" },
                            @{@"name" : @"Buffets", @"code": @"buffets" },
                            @{@"name" : @"Bulgarian", @"code": @"bulgarian" },
                            @{@"name" : @"Burgers", @"code": @"burgers" },
                            @{@"name" : @"Burmese", @"code": @"burmese" },
                            @{@"name" : @"Cafes", @"code": @"cafes" },
                            @{@"name" : @"Cafeteria", @"code": @"cafeteria" },
                            @{@"name" : @"Cajun/Creole", @"code": @"cajun" },
                            @{@"name" : @"Cambodian", @"code": @"cambodian" },
                            @{@"name" : @"Canadian", @"code": @"New)" },
                            @{@"name" : @"Canteen", @"code": @"canteen" },
                            @{@"name" : @"Caribbean", @"code": @"caribbean" },
                            @{@"name" : @"Catalan", @"code": @"catalan" },
                            @{@"name" : @"Chech", @"code": @"chech" },
                            @{@"name" : @"Cheesesteaks", @"code": @"cheesesteaks" },
                            @{@"name" : @"Chicken Shop", @"code": @"chickenshop" },
                            @{@"name" : @"Chicken Wings", @"code": @"chicken_wings" },
                            @{@"name" : @"Chilean", @"code": @"chilean" },
                            @{@"name" : @"Chinese", @"code": @"chinese" },
                            @{@"name" : @"Comfort Food", @"code": @"comfortfood" },
                            @{@"name" : @"Corsican", @"code": @"corsican" },
                            @{@"name" : @"Creperies", @"code": @"creperies" },
                            @{@"name" : @"Cuban", @"code": @"cuban" },
                            @{@"name" : @"Curry Sausage", @"code": @"currysausage" },
                            @{@"name" : @"Cypriot", @"code": @"cypriot" },
                            @{@"name" : @"Czech", @"code": @"czech" },
                            @{@"name" : @"Czech/Slovakian", @"code": @"czechslovakian" },
                            @{@"name" : @"Danish", @"code": @"danish" },
                            @{@"name" : @"Delis", @"code": @"delis" },
                            @{@"name" : @"Diners", @"code": @"diners" },
                            @{@"name" : @"Dumplings", @"code": @"dumplings" },
                            @{@"name" : @"Eastern European", @"code": @"eastern_european" },
                            @{@"name" : @"Ethiopian", @"code": @"ethiopian" },
                            @{@"name" : @"Fast Food", @"code": @"hotdogs" },
                            @{@"name" : @"Filipino", @"code": @"filipino" },
                            @{@"name" : @"Fish & Chips", @"code": @"fishnchips" },
                            @{@"name" : @"Fondue", @"code": @"fondue" },
                            @{@"name" : @"Food Court", @"code": @"food_court" },
                            @{@"name" : @"Food Stands", @"code": @"foodstands" },
                            @{@"name" : @"French", @"code": @"french" },
                            @{@"name" : @"French Southwest", @"code": @"sud_ouest" },
                            @{@"name" : @"Galician", @"code": @"galician" },
                            @{@"name" : @"Gastropubs", @"code": @"gastropubs" },
                            @{@"name" : @"Georgian", @"code": @"georgian" },
                            @{@"name" : @"German", @"code": @"german" },
                            @{@"name" : @"Giblets", @"code": @"giblets" },
                            @{@"name" : @"Gluten-Free", @"code": @"gluten_free" },
                            @{@"name" : @"Greek", @"code": @"greek" },
                            @{@"name" : @"Halal", @"code": @"halal" },
                            @{@"name" : @"Hawaiian", @"code": @"hawaiian" },
                            @{@"name" : @"Heuriger", @"code": @"heuriger" },
                            @{@"name" : @"Himalayan/Nepalese", @"code": @"himalayan" },
                            @{@"name" : @"Hong Kong Style Cafe", @"code": @"hkcafe" },
                            @{@"name" : @"Hot Dogs", @"code": @"hotdog" },
                            @{@"name" : @"Hot Pot", @"code": @"hotpot" },
                            @{@"name" : @"Hungarian", @"code": @"hungarian" },
                            @{@"name" : @"Iberian", @"code": @"iberian" },
                            @{@"name" : @"Indian", @"code": @"indpak" },
                            @{@"name" : @"Indonesian", @"code": @"indonesian" },
                            @{@"name" : @"International", @"code": @"international" },
                            @{@"name" : @"Irish", @"code": @"irish" },
                            @{@"name" : @"Island Pub", @"code": @"island_pub" },
                            @{@"name" : @"Israeli", @"code": @"israeli" },
                            @{@"name" : @"Italian", @"code": @"italian" },
                            @{@"name" : @"Japanese", @"code": @"japanese" },
                            @{@"name" : @"Jewish", @"code": @"jewish" },
                            @{@"name" : @"Kebab", @"code": @"kebab" },
                            @{@"name" : @"Korean", @"code": @"korean" },
                            @{@"name" : @"Kosher", @"code": @"kosher" },
                            @{@"name" : @"Kurdish", @"code": @"kurdish" },
                            @{@"name" : @"Laos", @"code": @"laos" },
                            @{@"name" : @"Laotian", @"code": @"laotian" },
                            @{@"name" : @"Latin American", @"code": @"latin" },
                            @{@"name" : @"Live/Raw Food", @"code": @"raw_food" },
                            @{@"name" : @"Lyonnais", @"code": @"lyonnais" },
                            @{@"name" : @"Malaysian", @"code": @"malaysian" },
                            @{@"name" : @"Meatballs", @"code": @"meatballs" },
                            @{@"name" : @"Mediterranean", @"code": @"mediterranean" },
                            @{@"name" : @"Mexican", @"code": @"mexican" },
                            @{@"name" : @"Middle Eastern", @"code": @"mideastern" },
                            @{@"name" : @"Milk Bars", @"code": @"milkbars" },
                            @{@"name" : @"Modern Australian", @"code": @"modern_australian" },
                            @{@"name" : @"Modern European", @"code": @"modern_european" },
                            @{@"name" : @"Mongolian", @"code": @"mongolian" },
                            @{@"name" : @"Moroccan", @"code": @"moroccan" },
                            @{@"name" : @"New Zealand", @"code": @"newzealand" },
                            @{@"name" : @"Night Food", @"code": @"nightfood" },
                            @{@"name" : @"Norcinerie", @"code": @"norcinerie" },
                            @{@"name" : @"Open Sandwiches", @"code": @"opensandwiches" },
                            @{@"name" : @"Oriental", @"code": @"oriental" },
                            @{@"name" : @"Pakistani", @"code": @"pakistani" },
                            @{@"name" : @"Parent Cafes", @"code": @"eltern_cafes" },
                            @{@"name" : @"Parma", @"code": @"parma" },
                            @{@"name" : @"Persian/Iranian", @"code": @"persian" },
                            @{@"name" : @"Peruvian", @"code": @"peruvian" },
                            @{@"name" : @"Pita", @"code": @"pita" },
                            @{@"name" : @"Pizza", @"code": @"pizza" },
                            @{@"name" : @"Polish", @"code": @"polish" },
                            @{@"name" : @"Portuguese", @"code": @"portuguese" },
                            @{@"name" : @"Potatoes", @"code": @"potatoes" },
                            @{@"name" : @"Poutineries", @"code": @"poutineries" },
                            @{@"name" : @"Pub Food", @"code": @"pubfood" },
                            @{@"name" : @"Rice", @"code": @"riceshop" },
                            @{@"name" : @"Romanian", @"code": @"romanian" },
                            @{@"name" : @"Rotisserie Chicken", @"code": @"rotisserie_chicken" },
                            @{@"name" : @"Rumanian", @"code": @"rumanian" },
                            @{@"name" : @"Russian", @"code": @"russian" },
                            @{@"name" : @"Salad", @"code": @"salad" },
                            @{@"name" : @"Sandwiches", @"code": @"sandwiches" },
                            @{@"name" : @"Scandinavian", @"code": @"scandinavian" },
                            @{@"name" : @"Scottish", @"code": @"scottish" },
                            @{@"name" : @"Seafood", @"code": @"seafood" },
                            @{@"name" : @"Serbo Croatian", @"code": @"serbocroatian" },
                            @{@"name" : @"Signature Cuisine", @"code": @"signature_cuisine" },
                            @{@"name" : @"Singaporean", @"code": @"singaporean" },
                            @{@"name" : @"Slovakian", @"code": @"slovakian" },
                            @{@"name" : @"Soul Food", @"code": @"soulfood" },
                            @{@"name" : @"Soup", @"code": @"soup" },
                            @{@"name" : @"Southern", @"code": @"southern" },
                            @{@"name" : @"Spanish", @"code": @"spanish" },
                            @{@"name" : @"Steakhouses", @"code": @"steak" },
                            @{@"name" : @"Sushi Bars", @"code": @"sushi" },
                            @{@"name" : @"Swabian", @"code": @"swabian" },
                            @{@"name" : @"Swedish", @"code": @"swedish" },
                            @{@"name" : @"Swiss Food", @"code": @"swissfood" },
                            @{@"name" : @"Tabernas", @"code": @"tabernas" },
                            @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
                            @{@"name" : @"Tapas Bars", @"code": @"tapas" },
                            @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates" },
                            @{@"name" : @"Tex-Mex", @"code": @"tex-mex" },
                            @{@"name" : @"Thai", @"code": @"thai" },
                            @{@"name" : @"Traditional Norwegian", @"code": @"norwegian" },
                            @{@"name" : @"Traditional Swedish", @"code": @"traditional_swedish" },
                            @{@"name" : @"Trattorie", @"code": @"trattorie" },
                            @{@"name" : @"Turkish", @"code": @"turkish" },
                            @{@"name" : @"Ukrainian", @"code": @"ukrainian" },
                            @{@"name" : @"Uzbek", @"code": @"uzbek" },
                            @{@"name" : @"Vegan", @"code": @"vegan" },
                            @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
                            @{@"name" : @"Venison", @"code": @"venison" },
                            @{@"name" : @"Vietnamese", @"code": @"vietnamese" },
                            @{@"name" : @"Wok", @"code": @"wok" },
                            @{@"name" : @"Wraps", @"code": @"wraps" },
                            @{@"name" : @"Yugoslav", @"code": @"yugoslav" }];
    return categories;
}
@end

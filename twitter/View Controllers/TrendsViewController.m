//
//  TrendsViewController.m
//  twitter
//
//  Created by alexhl09 on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TrendsViewController.h"
#import "../API/APIManager.h"
#import "TweetsTrendsViewController.h"
@interface TrendsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewTrends;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) NSArray * trendsRightNow;
@property (nonatomic,strong) NSArray * trendsRightNowFiltered;
@property (nonatomic, strong) NSDictionary * selectedTrend;

@end

@implementation TrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _trendsRightNow = [NSArray new];
    _tableViewTrends.delegate = self;
    _tableViewTrends.dataSource = self;
     _searchBar.delegate = self;
    [self getTrends];
    
   
    // Do any additional setup after loading the view.
}

/// This method shows the cancel button
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

/// This method makes the search bar first responder

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

///This method filters all the trends using my array and creating a new one that is used to populate the cells
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"name"] containsString:searchText];
        }];
        self.trendsRightNowFiltered = [self.trendsRightNow filteredArrayUsingPredicate:predicate];
        

        
    }
    else {
        self.trendsRightNowFiltered = self.trendsRightNow;
    }
    
    [self.tableViewTrends reloadData];
    
}
/**
 This method get the most popular trends around the world by a call to the API Manager
 */

-(void) getTrends
{

    [[APIManager shared] trends:^(NSArray *trends, NSError *error)
     {
         if (trends) {
             NSLog(@"😎😎😎 Successfully loaded home timeline");
             NSDictionary *trendsDic = trends[0];
             NSArray * trend = trendsDic[@"trends"];
             _trendsRightNow = trend;
             _trendsRightNowFiltered = trend;
             for(NSDictionary * infoTrend in trend)
             {
                 NSLog(@"%@",infoTrend[@"name"]);
             }
             [_tableViewTrends reloadData];

         } else {
             NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
         }
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/// This method is going to send the selected trend to the other view with all the tweets about that topic
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TweetsTrendsViewController * vc = [segue destinationViewController];
    [vc setKeyWord:_selectedTrend];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString * identifier = @"cell";
    UITableViewCell *myCell = [_tableViewTrends dequeueReusableCellWithIdentifier:identifier];
    
    NSString * nameOfTrend = _trendsRightNowFiltered[indexPath.row][@"name"];
    myCell.textLabel.text = nameOfTrend;
    return myCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _trendsRightNowFiltered.count;
}

/// Here I get the tweet selected in the table view and use it to prepare the data that I am going to send

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedTrend = _trendsRightNowFiltered[indexPath.row];
    [self performSegueWithIdentifier:@"detail" sender:self];
}




@end

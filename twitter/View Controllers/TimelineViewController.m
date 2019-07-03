//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "ComposeViewController.h"
#import "../Cells/TweetCell.h"

@import AFNetworking;
@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate>

@end


@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    //The delegate and the data source is the View Controller TimelineViewController
    _tableViewTimeline.delegate = self;
    _tableViewTimeline.dataSource = self;
    
    _myTweets = [NSArray new];
    
 
    
    [self getTimeline];
   

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [_tableViewTimeline insertSubview:refreshControl atIndex:0];
}


-(void) getTimeline
{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error)
     {
         if (tweets) {
             NSLog(@"😎😎😎 Successfully loaded home timeline");
             NSLog(@"%@",tweets);
             _myTweets = tweets;
             [_tableViewTimeline reloadData];
         } else {
             NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *celldentifier = @"cell";
    
    TweetCell *myCell = [_tableViewTimeline dequeueReusableCellWithIdentifier:celldentifier];
  
    Tweet * tweet =  [_myTweets objectAtIndex:indexPath.row];
    // My cell is going to receive the information of the tweet
    [myCell setTweet: tweet];
    TTTAttributedLabel *attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[tweet text]
                                                                    attributes:@{
                                                                                 (id)kCTForegroundColorAttributeName : (id)[UIColor blackColor].CGColor,
                                                                                 NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f],
                                                                                 NSKernAttributeName : [NSNull null],
                                                                                 (id)kTTTBackgroundFillColorAttributeName : (id)[UIColor whiteColor].CGColor
                                                                                 }];
    // Automatically detect links when the label text is subsequently changed
    myCell.tweetLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    myCell.tweetLabel.delegate = self;

  myCell.tweetLabel.text = attString;
    myCell.nameLabel.text = [[tweet user] name];
    NSString *atForUserName = @"@";
    myCell.userLabel.text = [atForUserName stringByAppendingString: [[tweet user] screenName]];
    myCell.dateLabel.text = [tweet createdAtString];
    
    // Get the profile image from the url
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[tweet user] urlProfilePhoto]]];
    
    [myCell.profilePicture setImageWithURLRequest:request placeholderImage:nil
                                      success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                          
                                          [UIView transitionWithView:myCell.profilePicture duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                              [myCell.profilePicture setImage:image];
                                          } completion:nil];
                                          
                                          
                                      }
                                      failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                          // do something for the failure condition
                                      }];
    
    // The profile picture is going to be in a circle
    myCell.profilePicture.layer.cornerRadius = myCell.profilePicture.frame.size.height / 2;
    [myCell.profilePicture setClipsToBounds:YES];
    
    
    //My cell is going to get the number of likes the tweet got before
    [myCell.loveButton setTitle: [NSString stringWithFormat:@"%i", [tweet favoriteCount]] forState:(UIControlStateNormal)];

    //My cell is going to get the number of retweets the tweet got before
    [myCell.retweetButton setTitle: [NSString stringWithFormat:@"%i", [tweet retweetCount]] forState:(UIControlStateNormal)];
    
    
    
    
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myTweets.count;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}



- (void)didTweet:(nonnull Tweet *)tweet
{
    [_myTweets addObject:tweet];
    [_tableViewTimeline reloadData];
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl
{
    

    [_tableViewTimeline reloadData];
    
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}


@end

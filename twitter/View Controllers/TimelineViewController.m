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
#import "../Models/User.h"
#import "ProfileTweetViewController.h"
#import "DetailViewController.h"
@import DateTools;

@import AFNetworking;
@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate, TweetCellDelegate, TweetDetailDelegate>

// My View Controller has a table View that is going to display all my tweets
@property (weak, nonatomic) IBOutlet UITableView *tableViewTimeline;
@property (strong, nonatomic) NSMutableArray * myTweets;
@property (strong, nonatomic) User * userSelected;
@property (strong, nonatomic) Tweet * tweetSelected;
@end


@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    //The delegate and the data source is the View Controller TimelineViewController
    _tableViewTimeline.delegate = self;
    _tableViewTimeline.dataSource = self;
    
    
    _tableViewTimeline.rowHeight = UITableViewAutomaticDimension;
    _tableViewTimeline.estimatedRowHeight = UITableViewAutomaticDimension;

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
       static NSMutableString *celldentifier = @"cell";
   
    
    
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
//    
//    if([_myTweets[indexPath.row] entities] == nil){
//        [myCell.imageTweet setHidden:YES];
//        
//    }else
//    {
//        [myCell.imageTweet setHidden:NO];
//        NSDictionary * myUrl = [_myTweets[indexPath.row] entities][0];
//        [myCell.imageView setImageWithURL:[NSURL URLWithString: myUrl[@"media_url_https"]]];
//    }
    


  myCell.tweetLabel.text = attString;
    myCell.nameLabel.text = [[tweet user] name];
    NSString *atForUserName = @"@";
    myCell.userLabel.text = [atForUserName stringByAppendingString: [[tweet user] screenName]];
    NSDate * dateTweet = [NSDate dateWithString:[tweet createdAtString] formatString:@"MM/dd/yy"];
    myCell.dateLabel.text = [dateTweet shortTimeAgoSinceNow];
    
    
    // Get the profile image from the url
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[tweet user] urlProfilePhoto]]];
    
    [myCell.profilePicture setImageWithURLRequest:request placeholderImage:nil
                                      success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                          
                                          [UIView transitionWithView:myCell.profilePicture duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
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
    
    if(tweet.retweeted)
    {
        [myCell.retweetButton setImage: [UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [myCell.retweetButton setSelected:NO];
        
        
    }else
    {
        [myCell.retweetButton setImage: [UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [myCell.retweetButton setSelected:NO];
        
    }
    
    
    if(tweet.favorited)
    {
        [myCell.loveButton setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [myCell.loveButton setSelected:NO];
        
        
    }else
    {
        [myCell.loveButton setImage: [UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [myCell.loveButton setSelected:NO];
        
    }
    myCell.delegate = self;
    
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tweetSelected = _myTweets[indexPath.row];
    [self performSegueWithIdentifier:@"detailTweet" sender:self];
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
    if([[segue identifier] isEqualToString:@"composite"])
    {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }else if ([[segue identifier] isEqualToString:@"detailTweet"]){
        DetailViewController * vc = [segue destinationViewController];
        [vc setTweet:_tweetSelected];
        vc.delegate = self;
    }else
    {
        ProfileTweetViewController * vc = [segue destinationViewController];
        
        [vc setUserTweet: _userSelected];
        
    }
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
    
 [self getTimeline];
   
    
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user
{
    // TODO: Perform segue to profile view controller
    _userSelected = user;

    [self performSegueWithIdentifier:@"profileSegue" sender:user];

}




- (void)tweetModified:(nonnull Tweet *)tweet
{
    NSLog(@"hola");
    [self getTimeline];
    
}

@end

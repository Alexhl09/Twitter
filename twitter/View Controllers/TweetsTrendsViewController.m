//
//  TweetsTrendsViewController.m
//  twitter
//
//  Created by alexhl09 on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetsTrendsViewController.h"
#import "../API/APIManager.h"
#import "../Cells/TweetCell.h"
@import AFNetworking;
@import DateTools;
@interface TweetsTrendsViewController () <UITableViewDataSource, UITableViewDelegate>
-(void) getTrendsTweets;
@property (nonatomic, strong) NSArray * myTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableViewTweets;


@end

@implementation TweetsTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableViewTweets.delegate = self;
    _tableViewTweets.dataSource = self;
    [self getTrendsTweets];
    self.title = self.keyWord[@"name"];
    
    
    // Do any additional setup after loading the view.
}


/**
 This method is going to send a call to the API manager that is going to look for all the tweets related to the topic that was selected in the previous view.
 */

-(void) getTrendsTweets
{
    
    [[APIManager shared] searchTweet: self.keyWord[@"name"] completion:^(NSDictionary *trends, NSError *error)
     {
         if (trends) {
             NSLog(@"😎😎😎 Successfully loaded home timeline");
  
             self->_myTweets = trends[@"statuses"];
             [_tableViewTweets reloadData];
             
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString * identifier = @"cell";
    TweetCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.tweetLabel.text = _myTweets[indexPath.row][@"text"];
    

    
    User * userTweet = [[User alloc] initWithDictionary:_myTweets[indexPath.row][@"user"]];
    //NSString * tweet = _myTweets[indexPath.row][@"search_metadata"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[userTweet urlProfilePhoto]]];
    
    [cell.profilePicture setImageWithURLRequest:request placeholderImage:nil
                                          success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                              
                                              [UIView transitionWithView:cell.profilePicture duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                                  [cell.profilePicture setImage:image];
                                              } completion:nil];
                                              
                                              
                                          }
                                          failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                              // do something for the failure condition
                                          }];
    
    // The profile picture is going to be in a circle
    cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.height / 2;
    [cell.profilePicture setClipsToBounds:YES];
    
    cell.nameLabel.text = [userTweet name];
    cell.userLabel.text = [userTweet screenName];

    NSDate * dateTweet = [NSDate dateWithString:_myTweets[indexPath.row][@"created_at"] formatString:@"E MMM d HH:mm:ss Z y"];
    cell.dateLabel.text = [dateTweet shortTimeAgoSinceNow];

    
    
    //My cell is going to get the number of likes the tweet got before
    [cell.loveButton setTitle: [NSString stringWithFormat:@"%@", _myTweets[indexPath.row][@"favorite_count"]] forState:(UIControlStateNormal)];
    
    //My cell is going to get the number of retweets the tweet got before
    [cell.retweetButton setTitle: [NSString stringWithFormat:@"%@", _myTweets[indexPath.row][@"retweet_count"]] forState:(UIControlStateNormal)];
    
    if(!_myTweets[indexPath.row][@"retweeted"])
    {
        [cell.retweetButton setImage: [UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [cell.retweetButton setSelected:NO];
        
        
    }else
    {
        [cell.retweetButton setImage: [UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [cell.retweetButton setSelected:NO];
        
    }
    
    
    if(!_myTweets[indexPath.row][@"favorited"])
    {
        [cell.loveButton setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [cell.loveButton setSelected:NO];
        
        
    }else
    {
        [cell.loveButton setImage: [UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [cell.loveButton setSelected:NO];
        
    }
    
    
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myTweets.count;
}

@end

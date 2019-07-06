//
//  ProfileTweetViewController.m
//  twitter
//
//  Created by alexhl09 on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ProfileTweetViewController.h"
#import "../Models/User.h"
#import "../API/APIManager.h"
#import "../Cells/TweetCell.h"
@import AFNetworking;
@import DateTools;
@interface ProfileTweetViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *verifiedImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundProfile;

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *followed;
@property (weak, nonatomic) IBOutlet UITableView *myTweetsTableView;
@property (strong, nonatomic) NSArray * myTweets;
-(void) getMyTweets;


@end

@implementation ProfileTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_userTweet);
    
    _myTweetsTableView.delegate = self;
    _myTweetsTableView.dataSource = self;
   
    self.title = [_userTweet name];
    self.name.text = [_userTweet name];
    self.userName.text = [[NSString stringWithFormat:@"@"] stringByAppendingString:[_userTweet screenName]];
    self.followers.text = [[NSString stringWithFormat:@"%@",[_userTweet followers]] stringByAppendingString:@" followers"];
    self.followed.text = [[NSString stringWithFormat:@"%@",[_userTweet friends]] stringByAppendingString:@" following"];
    

    [self.profilePhoto setImageWithURL:[NSURL URLWithString: [_userTweet urlProfilePhoto]]];
    [self.profilePhoto setClipsToBounds:YES];
    self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.height / 2;
    
    [self.backgroundProfile setImageWithURL:[NSURL URLWithString: [_userTweet urlBackgroundPhoto]]];
    
//    if(_userTweet.verify == YES)
//    {
//        [self.verifiedImage setImage:[UIImage imageNamed:@"selected-icon"]];
//
//    }
    
    [self getMyTweets];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getMyTweets) forControlEvents:UIControlEventValueChanged];
    [_myTweetsTableView insertSubview:refreshControl atIndex:0];
    // Do any additional setup after loading the view.
}

-(void) getMyTweets
{
    [[APIManager shared] getTweetsUser:[_userTweet screenName] completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😁");
            
            _myTweets = tweets;
            [_myTweetsTableView reloadData];
            
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
    TweetCell * myCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    User * user = [_myTweets[indexPath.row] user];
    myCell.nameLabel.text = [user name];
    myCell.userLabel.text = [[NSString stringWithFormat:@"@"] stringByAppendingString:[user screenName]];
    myCell.tweetLabel.text = [_myTweets[indexPath.row] text];
    
    [myCell.profilePicture setImageWithURL:[NSURL URLWithString: [user urlProfilePhoto]]];
    
    NSDate * dateTweet = [NSDate dateWithString:[_myTweets[indexPath.row] createdAtString] formatString:@"MM/dd/yy"];
    myCell.dateLabel.text = [dateTweet shortTimeAgoSinceNow];
    
    //My cell is going to get the number of likes the tweet got before
    [myCell.loveButton setTitle: [NSString stringWithFormat:@"%i", [_myTweets[indexPath.row] favoriteCount]] forState:(UIControlStateNormal)];
    
    //My cell is going to get the number of retweets the tweet got before
    [myCell.retweetButton setTitle: [NSString stringWithFormat:@"%i", [_myTweets[indexPath.row] retweetCount]] forState:(UIControlStateNormal)];
    
    if([_myTweets[indexPath.row] retweeted])
    {
        [myCell.retweetButton setImage: [UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [myCell.retweetButton setSelected:NO];
        
        
    }else
    {
        [myCell.retweetButton setImage: [UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [myCell.retweetButton setSelected:NO];
        
    }
    
    
    if([_myTweets[indexPath.row] favorited])
    {
        [myCell.loveButton setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [myCell.loveButton setSelected:NO];
        
        
    }else
    {
        [myCell.loveButton setImage: [UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [myCell.loveButton setSelected:NO];
        
    }
    // The profile picture is going to be in a circle
    myCell.profilePicture.layer.cornerRadius = myCell.profilePicture.frame.size.height / 2;
    [myCell.profilePicture setClipsToBounds:YES];
    myCell.tweet = _myTweets[indexPath.row];
    return myCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myTweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end

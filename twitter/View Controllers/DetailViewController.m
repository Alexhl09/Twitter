//
//  DetailViewController.m
//  twitter
//
//  Created by alexhl09 on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import "../Models/Tweet.h"
#import "../Models/User.h"
#import "../API/APIManager.h"
@import AFNetworking;
@import DateTools;
@interface DetailViewController () 
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageTweet;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    User * user = [_tweet user];
    [_profileImage setImageWithURL:[NSURL URLWithString:[user urlProfilePhoto]]];
    [_name setText:[user name]];
    [_screenName setText:[user screenName]];
    NSDate * dateTweet = [NSDate dateWithString:[_tweet createdAtString] formatString:@"MM/dd/yy"];
    [_dateLabel setText: [dateTweet shortTimeAgoSinceNow]];
    [_tweetLabel setText:[_tweet text]];
    _profileImage.layer.cornerRadius = _profileImage.frame.size.height / 2;
    [_profileImage setClipsToBounds:YES];
   

    if(_tweet.retweeted)
    {
        [_retweetButton setImage: [UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [_retweetButton setSelected:NO];
        
        
    }else
    {
        [_retweetButton setImage: [UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [_retweetButton setSelected:NO];
        
    }
    
    
    if(_tweet.favorited)
    {
        [_favoriteButton setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [_favoriteButton setSelected:NO];
        
        
    }else
    {
        [_favoriteButton setImage: [UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [_favoriteButton setSelected:NO];
        
    }

    
    [_favoriteButton setTitle: [NSString stringWithFormat:@"%i", [_tweet favoriteCount]] forState:(UIControlStateNormal)];
    
    [_retweetButton setTitle: [NSString stringWithFormat:@"%i", [_tweet retweetCount]] forState:(UIControlStateNormal)];
    // Do any additional setup after loading the view.
}
- (IBAction)retweet:(UIButton *)sender
{
    if(_tweet.retweeted)
    {
        _tweet.retweetCount -= 1;
        [[APIManager shared] unretweet:_tweet completion:^(Tweet * tweet, NSError *error) {
         
        }];
        [_retweetButton setImage: [UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [_retweetButton setSelected:NO];
        [_tweet setRetweeted:NO];
    }else
    {
        _tweet.retweetCount += 1;
        [[APIManager shared] retweet:_tweet completion:^(Tweet * tweet, NSError *error) {
           
        }];
        [_retweetButton setImage: [UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [_retweetButton setSelected:NO];
        [_tweet setRetweeted:YES];
    }
       [_retweetButton setTitle: [NSString stringWithFormat:@"%i", [_tweet retweetCount]] forState:(UIControlStateNormal)];
    [self tweetModified:_tweet];
}
- (IBAction)favorite:(UIButton *)sender
{
    
    if(_tweet.favorited)
    {
        _tweet.favoriteCount -= 1;
        [[APIManager shared] unfavorite:_tweet completion:^(Tweet * tweet, NSError * error) {
            [_favoriteButton setImage: [UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
            [_favoriteButton setSelected:NO];
            [_tweet setFavorited:NO];
        }];
    }else
    {
        _tweet.favoriteCount += 1;
        [[APIManager shared] favorite:_tweet completion:^(Tweet * tweet, NSError * error) {
            [_favoriteButton setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
            [_favoriteButton setSelected:NO];
            [_tweet setFavorited:YES];
            
        }];
    }
    
    [_favoriteButton setTitle: [NSString stringWithFormat:@"%i", [_tweet favoriteCount]] forState:(UIControlStateNormal)];
    
  
    [self tweetModified:_tweet];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tweetModified:(nonnull Tweet *)tweet
{
    NSLog(@"hey");
     [self.delegate tweetModified:tweet];
}


@end

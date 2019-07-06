//
//  ProfileViewController.m
//  twitter
//
//  Created by alexhl09 on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "../API/APIManager.h"
#import "../Cells/TweetCell.h"
@import AFNetworking;
@import DateTools;
@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UITableView *tableViewTweets;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (strong, nonatomic) NSString * myProfileName;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) NSArray * myTweets;
@property (strong, nonatomic) User * me;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myTweets = [NSArray new];
    _tableViewTweets.delegate = self;
    _tableViewTweets.dataSource = self;
    

    [self getUser];
    
    
    // Do any additional setup after loading the view.
}


/**
 This method gets the information of the user, and call the API Manager to get the information of that profile
 Parameters:
 - Screenname: that is a variable in the view controller taht is sent by the previuos view controller
 */
-(void) getUser
{

    [[APIManager shared] getUser:^(NSDictionary *infoUser, NSError *error)
     {
         if (infoUser) {
             self.myProfileName = infoUser[@"screen_name"];
      
        
             [self getMyTweets];
             NSLog(@"%@", infoUser);
         } else {
             NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
         }
     }];
}

/**
 This is a method to go back to the first View controller and sign in witha  different account
 
 Parameters:
 -sender
 */
- (IBAction)loggingOut:(UIBarButtonItem *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
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
    if([[user screenName] isEqualToString: _myProfileName]){
        _me = user;
        [_profilePhoto setImageWithURL:[NSURL URLWithString: [user urlProfilePhoto]]];
        [_backgroundImage setImageWithURL:[NSURL URLWithString: [user urlBackgroundPhoto]]];
        [_name setText:[user name]];
        [_screenName setText:[[NSString stringWithFormat:@"@"] stringByAppendingString:[user screenName]]];
        [_followers setText:[[NSString stringWithFormat:@"%@",[user followers]] stringByAppendingString:@" followers"]];
        [_following setText:[[NSString stringWithFormat:@"%@",[user friends]] stringByAppendingString:@" following"]];
       
        
    }
    
    // The profile picture is going to be in a circle
    myCell.profilePicture.layer.cornerRadius = myCell.profilePicture.frame.size.height / 2;
    [myCell.profilePicture setClipsToBounds:YES];
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
    
    myCell.tweet = _myTweets[indexPath.row];
    return myCell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
     return _myTweets.count;
    
}


/**
This getTweetsUser method in the API Manager uses the variable myProfileName and get all the tweets from that user, and then reload all the data to populate again the cells with all the tweets taht we received from the API MAnager
 */

-(void) getMyTweets
{
    [[APIManager shared] getTweetsUser:self.myProfileName  completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😁");
            _myTweets = tweets;
            
            [_tableViewTweets reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

//
//  MentionsViewController.m
//  twitter
//
//  Created by alexhl09 on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "MentionsViewController.h"
#import "../API/APIManager.h"
#import "../Cells/TweetCell.h"
@import DateTools;
@import AFNetworking;
@interface MentionsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewMentions;
@property (strong, nonatomic) NSArray * myMentions;
@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myMentions = [NSArray new];
    _tableViewMentions.delegate = self;
    _tableViewMentions.dataSource = self;
    [[APIManager shared] getMentions:^(NSArray *mentions, NSError *error) {
        NSLog(@"%@",mentions);
        if(error)
        {
            
        }else
        {
            _myMentions = mentions;
            [_tableViewMentions reloadData];
        }
    }];
    // Do any additional setup after loading the view.
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
    User * user = [_myMentions[indexPath.row] user];
    myCell.nameLabel.text = [user name];
    myCell.userLabel.text = [[NSString stringWithFormat:@"@"] stringByAppendingString:
    [user screenName]];
    myCell.tweetLabel.text = [_myMentions[indexPath.row] text];
    
    [myCell.profilePicture setImageWithURL:[NSURL URLWithString: [user urlProfilePhoto]]];
    
    NSDate * dateTweet = [NSDate dateWithString:[_myMentions[indexPath.row] createdAtString] formatString:@"MM/dd/yy"];
    myCell.dateLabel.text = [dateTweet shortTimeAgoSinceNow];
    
    //My cell is going to get the number of likes the tweet got before
    [myCell.loveButton setTitle: [NSString stringWithFormat:@"%i", [_myMentions[indexPath.row] favoriteCount]] forState:(UIControlStateNormal)];
    
    //My cell is going to get the number of retweets the tweet got before
    [myCell.retweetButton setTitle: [NSString stringWithFormat:@"%i", [_myMentions[indexPath.row] retweetCount]] forState:(UIControlStateNormal)];
    
    if([_myMentions[indexPath.row] retweeted])
    {
        [myCell.retweetButton setImage: [UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [myCell.retweetButton setSelected:NO];
        
        
    }else
    {
        [myCell.retweetButton setImage: [UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [myCell.retweetButton setSelected:NO];
        
    }
    
    
    if([_myMentions[indexPath.row] favorited])
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
    myCell.tweet = _myMentions[indexPath.row];
    return myCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myMentions.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


@end

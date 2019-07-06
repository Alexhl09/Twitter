//
//  TweetCell.h
//  twitter
//
//  Created by alexhl09 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/Tweet.h"
#import "TTTAttributedLabel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TweetCellDelegate;
@interface TweetCell : UITableViewCell
// My tweet that is going to store all the information of each cell in case of need it
@property (weak, nonatomic) Tweet * tweet;
// Profile picture
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
// Label with the name of the user
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *nameLabel;
// User name
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
// Date text
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
// Date text
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetLabel;
// Reply button
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
// Retweet button
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
// Favorite button
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
// Delegate of the delegate TWeet Cell Delegate
@property (nonatomic, weak) id<TweetCellDelegate> delegate;
// Image of the tweet
@property (weak, nonatomic) IBOutlet UIImageView *imageTweet;

// This function refresh the data of a tweet that has been marked as favorite
-(void) refreshDataAfterFavorite;
// This function refresh the data of a tweet that has been marked as retweeted
-(void) refreshDataAfterRetweet;

@end
// Protocol Tweet Cell delegate that has a method thta indictates that a user has taped on the image of the user in the cell
@protocol TweetCellDelegate
- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;
@end

NS_ASSUME_NONNULL_END

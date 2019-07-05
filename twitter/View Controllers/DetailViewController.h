//
//  DetailViewController.h
//  twitter
//
//  Created by alexhl09 on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/Tweet.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TweetDetailDelegate
- (void)tweetModified:  (Tweet *)tweet;
@end
@interface DetailViewController : UIViewController
@property (strong, nonatomic) Tweet * tweet;
@property (nonatomic, weak) id<TweetDetailDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

//
//  ComposeViewController.h
//  twitter
//
//  Created by alexhl09 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
@import SFProgressCircle;
NS_ASSUME_NONNULL_BEGIN
@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end
@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet SFCircleGradientView *circleCountCharacters;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END


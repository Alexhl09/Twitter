//
//  TweetCell.m
//  twitter
//
//  Created by alexhl09 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "../API/APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)didTapFavorite:(UIButton *)sender {
    
    if(self.tweet.favorited){
    // TODO: Update the local tweet model
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    
    
    // TODO: Update cell UI
    [self refreshData];
    
    // TODO: Send a POST request to the POST favorites/create endpoint
    
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
    }else{
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        
        // TODO: Update cell UI
        [self refreshData];
        
        // TODO: Send a POST request to the POST favorites/create endpoint
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
        
    }
}
-(void) refreshData{
    if(self.tweet.favorited){
        [self.loveButton.imageView setImage: [UIImage imageNamed:@"favor-icon-red"]];
    }else{
         [self.loveButton.imageView setImage:[UIImage imageNamed:@"favor-icon"]];
    }
    
}



@end

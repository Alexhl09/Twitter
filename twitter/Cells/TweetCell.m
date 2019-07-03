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

- (IBAction)didTapRetweet:(UIButton *)sender {
    if(!self.tweet.retweeted)
    {
    [[APIManager shared] retweet: self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error)
        {
            NSLog(@"Error ree tweet: %@", error.localizedDescription);
             [self refreshDataAfterRetweet];
        }
        else
        {
            NSLog(@"Successfully ree the following Tweet: %@", tweet.text);

            self.tweet.retweeted = YES;
            self.tweet.retweetCount += 1;
       [self refreshDataAfterRetweet];
        }
    }];
    }else
    {
        [[APIManager shared] unretweet: self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error)
            {
                NSLog(@"Error ree tweet: %@", error.localizedDescription);
                [self refreshDataAfterRetweet];
            }
            else
            {
                NSLog(@"Successfully ree the following Tweet: %@", tweet.text);
                
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                
                [self refreshDataAfterRetweet];
                
            }
        }];
       
        
    }
    
    
}


- (IBAction)didTapFavorite:(UIButton *)sender {
    

    if(!self.tweet.favorited){
    NSLog(@"FAv");
    // TODO: Update the local tweet model
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    
    // TODO: Update cell UI
    [self refreshDataAfterFavorite];
    
    // TODO: Send a POST request to the POST favorites/create endpoint
    
    [[APIManager shared] favorite: self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error)
        {
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else
        {
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
        
        
    }else{
        NSLog(@"NoFAv");
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        
        // TODO: Update cell UI
        [self refreshDataAfterFavorite];
        
        // TODO: Send a POST request to the POST favorites/create endpoint
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error)
            {
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else
            {
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
        
    }
}
-(void) refreshDataAfterFavorite{
    if(self.tweet.favorited)
    {
        [self.loveButton setImage: [UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [self.loveButton setSelected:NO];
       

    }else
    {
        [self.loveButton setImage: [UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [self.loveButton setSelected:NO];
        
    }
    [self.loveButton setTitle: [NSString stringWithFormat:@"%i", [self.tweet favoriteCount]] forState:(UIControlStateNormal)];

    
}


-(void) refreshDataAfterRetweet{
    if(self.tweet.retweeted)
    {
        [self.retweetButton setImage: [UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [self.retweetButton setSelected:NO];
        
        
    }else
    {
        [self.retweetButton setImage: [UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [self.retweetButton setSelected:NO];
        
    }
    [self.retweetButton setTitle: [NSString stringWithFormat:@"%i", [self.tweet retweetCount]] forState:(UIControlStateNormal)];
    
    
}


@end

//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"


static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"5lUJuO5AUpPUCez4ewYDFrtgh";// Enter your consumer key here
static NSString * const consumerSecret = @"s5ynGqXzstUZwFPxVyMDkYh197qvHOcVM3kwv1o2TKhS1avCdS"; // Enter your consumer secret here

@interface APIManager()

@end

@implementation APIManager


///
/// This shared property is going to let me call funtions inside this private class
///
///
+ (instancetype)shared
{
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}


 /**
 This method is going to get all the 200 tweets from my own timeline

  
 - Parameters:
        - nil

 - Returns:
        - tweets: This *tweets* is an array that is going to help me to populate the tweets of the timeline.
        - error: If there is an error I will get a NSError object that is going to help me to figure out the problem.
   */

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion
{
    NSDictionary *parameters = @{@"count": @"200", @"include_rts" : @YES};
    
    
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
  
     NSLog(@"%@", tweetDictionaries);
       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
       completion(tweets, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       completion(nil, error); 
   }];
}

/**
 This funtion is going to post a Tweet.
 
 - Parameters:
 - text: This text is the text that the user wants to post in their own Twitter

 
 - Returns: Completion with the tweet tweeted and an error if there was a problem twitting the text
 */
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion
{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {

        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];

        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


/**
 This funtion is going to favourite a tweet
 
 - Parameters:
 - tweet: This tweet is the one that is going to be marked as favourite
 
 
 - Returns: Completion with the tweet tweeted and an error if there was a problem marking the tweet as favourite
 */
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion
{
    
    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};

    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


/**
 This funtion is going to retweet a tweet
 
 - Parameters:
 - tweet: This tweet is the one that is going to be marked as retweeted
 
 
 - Returns: Completion with the tweet tweeted and an error if there was a problem retweeting the tweet
 */

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion
{
    
    NSString *urlString = @"1.1/statuses/retweet/";
    NSString * urlStringSecond = [urlString stringByAppendingString:tweet.idStr];
    NSString * finalString = [urlStringSecond stringByAppendingString:@".json"];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:finalString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


/**
 This funtion is going to unretweet a tweet
 
 - Parameters:
 - tweet: This tweet is the one that is going to be marked as unretweeted
 
 
 - Returns: Completion with the tweet tweeted and an error if there was a problem unretweeting the tweet
 */
- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion
{
    
    NSString *urlString = @"1.1/statuses/unretweet/";
    NSString * urlStringSecond = [urlString stringByAppendingString:tweet.idStr];
    NSString * finalString = [urlStringSecond stringByAppendingString:@".json"];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:finalString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}



/**
 This funtion is going to unfavourite a tweet
 
 - Parameters:
 - tweet: This tweet is the one that is going to be marked as unfavourite
 
 
 - Returns: Completion with the tweet tweeted
            - error if there was a problem marking the tweet as unfavourite
 */
- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion
{
    
    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

/**
 This funtion is going to get the trends in twitter
 
 - Parameters:
    - nil
 
 
 - Returns:
 - tweets: This is an array that is going to contain dictionaris of the most populat trends
 -  error: This is an error that is going to help me understand the reason why I cannot have the information of the trends
 */

- (void)trends:(void(^)(NSArray *tweets, NSError *error))completion
{
    
    NSString *urlString = @"1.1/trends/place.json";
    NSDictionary *parameters = @{@"id": @"1"};
    [self GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {

        completion(tweetDictionary, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


/**
  This funtion is going to get some tweets with certain key word
  
  - Parameters:
 - searchKey: This is the text taht tha API is going to look for in all the recent tweets
  
  
  - Returns:
  - tweets: This is an array that is going to contain dictionaries of tweets with the word searched
  -  error: This is an error that is going to help me understand the reason why I cannot have the information of the tweets
  */
-(void) searchTweet: (NSString *) searchKey  completion:(void(^)( NSDictionary *tweets, NSError *error))completion
{
    NSDictionary *parameters = @{@"q": searchKey, @"result_type" : @"popular"};
    
    
    [self GET:@"1.1/search/tweets.json"
   parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
       
       completion(tweetDictionaries, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       completion(nil, error);
   }];
}



-(void) getTweetsUser: (NSString * ) username completion:(void(^)(NSArray *tweets, NSError *error))completion
{
    NSDictionary *parameters = @{@"screen_name": username};
    
    
    [self GET:@"1.1/statuses/user_timeline.json"
   parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
       
       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
       completion(tweets, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       completion(nil, error);
   }];
}

-(void) getUser: (void(^)(NSDictionary *infoUser, NSError *error))completion
{

    
    
    [self GET:@"1.1/account/settings.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
       
      
       completion(tweetDictionaries, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       completion(nil, error);
   }];
}

-(void) getMessages: (void(^)(NSDictionary *messages, NSError *error))completion
{
    
    
    
    [self GET:@"1.1/direct_messages/events/list.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
       
       
       completion(tweetDictionaries, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       completion(nil, error);
   }];
}
@end

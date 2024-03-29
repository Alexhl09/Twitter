//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"
@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
- (void)trends:(void(^)(NSArray *tweets, NSError *error))completion;
-(void) searchTweet: (NSString *) searchKey  completion:(void(^)(NSDictionary *tweets, NSError *error))completion;
-(void) getTweetsUser: (NSString * ) username completion:(void(^)(NSArray *tweets, NSError *error))completion;
-(void) getUser: (void(^)(NSDictionary *infoUser, NSError *error))completion;
-(void) getMessages: (void(^)(NSDictionary *messages, NSError *error))completion;
-(void) getMentions: (void(^)(NSArray *mentions, NSError *error))completion;
@end

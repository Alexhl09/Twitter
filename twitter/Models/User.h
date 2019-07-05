//
//  User.h
//  twitter
//
//  Created by alexhl09 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
//My properties that I am going to use
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSURL * urlProfilePhoto;
@property (strong, nonatomic) NSURL * urlBackgroundPhoto;
@property (strong, nonatomic) NSString * profileLinkColor;
@property (strong, nonatomic) NSNumber * friends;
@property (strong, nonatomic) NSNumber * followers;
@property (nonatomic) BOOL verify;
@property ( nonatomic) BOOL following;
// Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END

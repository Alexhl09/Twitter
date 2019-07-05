//
//  User.m
//  twitter
//
//  Created by alexhl09 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"



@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
    {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.urlProfilePhoto = dictionary[@"profile_image_url_https"];
        self.urlBackgroundPhoto = dictionary[@"profile_banner_url"];
        self.profileLinkColor = dictionary[@"profile_link_color"];
        self.friends = dictionary[@"friends_count"];
        self.verify = dictionary[@"verified"];
        self.following = dictionary[@"following"];
        self.followers = dictionary[@"followers_count"];
        // Initialize any other properties
    }
    return self;
    

}

@end

//
//  TimelineViewController.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewTimeline;
@property (strong, nonatomic) NSMutableArray * myTweets;
-(void) getTimeline;
@end

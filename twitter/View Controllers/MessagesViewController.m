//
//  MessagesViewController.m
//  twitter
//
//  Created by alexhl09 on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "MessagesViewController.h"
#import "../API/APIManager.h"
@interface MessagesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * myMessages;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      _myMessages = [NSArray new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self getMessages];
  
    // Do any additional setup after loading the view.
}

-(void) getMessages
{
    // Get timeline
    [[APIManager shared] getMessages:^(NSDictionary *messages, NSError *error) {
        
            if (messages) {
                
                NSLog(@"%@",messages);
                
                NSArray* reversedArray = [[messages[@"events"] reverseObjectEnumerator] allObjects];
                _myMessages = reversedArray;
                [_tableView reloadData];
            } else {
                NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
            }
    
     
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary * infoMessage = _myMessages[indexPath.row][@"message_create"];
    myCell.textLabel.text = infoMessage[@"message_data"][@"text"];
    return myCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myMessages.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

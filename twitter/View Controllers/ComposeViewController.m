//
//  ComposeViewController.m
//  twitter
//
//  Created by alexhl09 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//J71JJO50WE5R

#import "ComposeViewController.h"
#import "APIManager.h"
#import "twitter-Swift.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageGif;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _circleCountCharacters.progress = 1.0;
    
    _tweetTextView.delegate = self;

    // Do any additional setup after loading the view.
}
- (IBAction)closeTweet:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

/** If the user tap on create a new tweet, this is going to be posted by the API Manager.
 And if it is successful I am going to call the protocol method and send the tweet that it was tweeted
 */
- (IBAction)didTapPost:(UIBarButtonItem *)sender
{
    NSString * myTweet = _tweetTextView.text;
    [[APIManager shared]postStatusWithText:myTweet completion:^(Tweet *tweet, NSError *error)
    {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}



- (IBAction)removeKeyboard:(UITapGestureRecognizer *)sender {
    
    [_tweetTextView resignFirstResponder];
}
/** There is a circle as animation to let know the user how many characters are left
 */
- (void)textViewDidChange:(UITextView *)textView
{
    NSUInteger length;
    length = [textView.text length];
    NSLog(@"%f",_circleCountCharacters.progress);
    _circleCountCharacters.progress = 1.0 - ((double) length / (double) 140);
   
}
/** The text view is not going to allow more than 140 characters
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 140;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void) getGIF
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GIFViewController * vc = [segue destinationViewController];


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

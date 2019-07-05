//
//  ComposeViewController.m
//  twitter
//
//  Created by alexhl09 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//J71JJO50WE5R

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () 

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

- (void)textViewDidChange:(UITextView *)textView
{
    NSUInteger length;
    length = [textView.text length];
    NSLog(@"%f",_circleCountCharacters.progress);
    _circleCountCharacters.progress = 1.0 - ((double) length / (double) 140);
   
}

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

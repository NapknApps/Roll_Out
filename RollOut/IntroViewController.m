//
//  IntroViewController.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "IntroViewController.h"
#import "DefaultsHelper.h"
#import "DayNightView.h"

@interface IntroViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSArray *explanations;
@property (nonatomic) int currentPage;
@property (weak, nonatomic) IBOutlet UIView *nextButtonBackgroundView;
@property (strong, nonatomic) UIImageView *chatBubble1;
@property (strong, nonatomic) UIImageView *chatBubble3;
@property (strong, nonatomic) UIImageView *barcodeImageView;

@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpIntro];
    
    self.nextButtonBackgroundView.layer.cornerRadius = self.nextButtonBackgroundView.frame.size.height/2;

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setUpIntro
{
    self.explanations = [NSArray arrayWithObjects:
                         [NSString stringWithFormat:@"Waking up is no fun..."],
                         [NSString stringWithFormat:@"But public shaming is worse."],
                         [NSString stringWithFormat:@"Sleep in and everyone will know."],
                         [NSString stringWithFormat:@"Unless you prove you're awake..."],
                         [NSString stringWithFormat:@"By scanning your shampoo."],
                         nil];
    
    for (int i = 0; i < self.explanations.count; i++) {

        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 400)];
        
        [textView setFont:[UIFont fontWithName:@"Avenir" size:32]];
        [textView setTextColor:[UIColor whiteColor]];
        textView.backgroundColor = [UIColor clearColor];
        textView.userInteractionEnabled = NO;
        [textView setText:[self.explanations objectAtIndex:i]];
        
        [subview addSubview:textView];
        
        if (i == 0) {
            NSDate *const date = NSDate.date;
            NSCalendar *const calendar = NSCalendar.currentCalendar;
            NSCalendarUnit const preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
            NSDateComponents *const components = [calendar components:preservedComponents fromDate:date];
            NSDate *const normalizedDate = [calendar dateFromComponents:components];
            
            DayNightView *dayNightView = [[DayNightView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 130) time:normalizedDate];
            [subview addSubview:dayNightView];
            
            [self performSelector:@selector(animateFirstFrame:) withObject:dayNightView afterDelay:.9];
        }
        
        self.chatBubble1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 285, 202)];
        [self.chatBubble1 setImage:[UIImage imageNamed:@"chat_left.png"]];
        [self.view addSubview:self.chatBubble1];
        self.chatBubble1.center = CGPointMake(self.chatBubble1.center.x, self.chatBubble1.center.y + (self.view.frame.size.height / 2));
        self.chatBubble1.alpha = 0.0;
        UITextView *textView2 = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, self.chatBubble1.frame.size.width - 40, self.chatBubble1.frame.size.height - 40)];
        [textView2 setFont:[UIFont fontWithName:@"Avenir" size:24]];
        [textView2 setTextColor:[UIColor darkGrayColor]];
        textView2.backgroundColor = [UIColor clearColor];
        textView2.userInteractionEnabled = NO;
        [textView2 setText:@"I slept in again :/ #RollOut"];
        [self.chatBubble1 addSubview:textView2];

        
        
        if (i == 4)
        {
            self.barcodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 160)];
            [self.barcodeImageView setImage:[UIImage imageNamed:@"barcode.png"]];
            [subview addSubview:self.barcodeImageView];
            self.barcodeImageView.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2) + 100);
            self.barcodeImageView.alpha = 0.0;
        }

        

        [self.scrollView addSubview:subview];
    }
    
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (self.explanations.count), self.scrollView.frame.size.height);
}

- (void)animateFirstFrame:(DayNightView *)dayNightView
{
    NSDate *const date = NSDate.date;
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSCalendarUnit const preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *const components = [calendar components:preservedComponents fromDate:date];
    NSDate *const normalizedDate = [calendar dateFromComponents:components];

    [dayNightView setDate:[normalizedDate dateByAddingTimeInterval:60*60*12] animated:YES];
}

- (void)animateSecondFrame
{
    [UIView animateWithDuration:.6 delay:.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.chatBubble1.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2) + 20);
        self.chatBubble1.alpha = 1.0;
        
    } completion:^(BOOL finished) { }];
}

- (void)animateThirdFrame
{
    [UIView animateWithDuration:.6 delay:.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.chatBubble1.center = CGPointMake(self.view.frame.size.width / 2, 0);
        self.chatBubble1.alpha = 0.0;
        
    } completion:^(BOOL finished) {
    
    }];
    
    
    
    UIImageView *chatBubble2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 285, 202)];
    [chatBubble2 setImage:[UIImage imageNamed:@"chat_right.png"]];
    [self.view addSubview:chatBubble2];
    chatBubble2.center = CGPointMake(chatBubble2.center.x, chatBubble2.center.y + (self.view.frame.size.height / 2));
    chatBubble2.alpha = 0.0;
    UITextView *textView2 = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, chatBubble2.frame.size.width - 40, chatBubble2.frame.size.height - 40)];
    [textView2 setFont:[UIFont fontWithName:@"Avenir" size:24]];
    [textView2 setTextColor:[UIColor darkGrayColor]];
    textView2.backgroundColor = [UIColor clearColor];
    textView2.userInteractionEnabled = NO;
    [textView2 setText:@"That's no good dude!"];
    [chatBubble2 addSubview:textView2];

    
    [UIView animateWithDuration:.6 delay:.8 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        chatBubble2.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2) + 20);
        chatBubble2.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
        
        self.chatBubble3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 285, 202)];
        [self.chatBubble3 setImage:[UIImage imageNamed:@"chat_right.png"]];
        [self.view addSubview:self.chatBubble3];
        self.chatBubble3.center = CGPointMake(self.chatBubble3.center.x, self.chatBubble3.center.y + (self.view.frame.size.height / 2));
        self.chatBubble3.alpha = 0.0;
        UITextView *textView3 = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, self.chatBubble3.frame.size.width - 40, self.chatBubble3.frame.size.height - 40)];
        [textView3 setFont:[UIFont fontWithName:@"Avenir" size:24]];
        [textView3 setTextColor:[UIColor darkGrayColor]];
        textView3.backgroundColor = [UIColor clearColor];
        textView3.userInteractionEnabled = NO;
        [textView3 setText:@"You can do better! I believe in you!"];
        [self.chatBubble3 addSubview:textView3];
        
        
        [UIView animateWithDuration:.6 delay:1.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            
            chatBubble2.center = CGPointMake(self.view.frame.size.width / 2, 0);
            chatBubble2.alpha = 0.0;

            
            self.chatBubble3.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2) + 20);
            self.chatBubble3.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            
            
            
            
            
            
        }];

        
        
        
    }];

    
}

- (void)animateForthFrame
{
    [UIView animateWithDuration:.6 delay:0.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.chatBubble3.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height);
        self.chatBubble3.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)animateFifthFrame
{
    [UIView animateWithDuration:.6 delay:0.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.barcodeImageView.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2) + 20);
        self.barcodeImageView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)nextButtonSelected:(id)sender
{
    if (self.currentPage < self.explanations.count) {
        self.currentPage++;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, 0) animated:YES];
    }
    
    if (self.currentPage == self.explanations.count - 1) {
        [self.nextButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    else if (self.currentPage == self.explanations.count) {
        [DefaultsHelper setIntroShown];
        [self dismissViewControllerAnimated:NO completion:^{
        }];
    }
    
    if (self.currentPage == 1) {
        [self performSelector:@selector(animateSecondFrame) withObject:nil afterDelay:.1];
    }
    else if (self.currentPage == 2) {
        [self performSelector:@selector(animateThirdFrame) withObject:nil afterDelay:.1];
    }
    else if (self.currentPage == 3) {
        [self performSelector:@selector(animateForthFrame) withObject:nil afterDelay:.1];
    }
    else if (self.currentPage == 4) {
        [self performSelector:@selector(animateFifthFrame) withObject:nil afterDelay:.1];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

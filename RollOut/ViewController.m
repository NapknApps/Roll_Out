//
//  ViewController.m
//  RollOut
//
//  Created by Zach Whelchel on 7/29/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DefaultsHelper.h"
#import <TwitterKit/Twitter.h>
#import "ScanViewController.h"
#import "DayNightView.h"

@interface ViewController () <ScanViewControllerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *alarmOnSwitch;
@property (strong, nonatomic) DayNightView *dayNightView;
@property (weak, nonatomic) IBOutlet UIView *buttonBackground;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic) BOOL shouldShowScan;

@end

@implementation ViewController

@synthesize audioPlayer = _audioPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.buttonBackground.layer.cornerRadius = self.buttonBackground.frame.size.height/2;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecameActive)
                                                 name:@"AppBecameActive"
                                               object:nil];

    
    
    NSDate *const date = NSDate.date;
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSCalendarUnit const preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *const components = [calendar components:preservedComponents fromDate:date];
    NSDate *const normalizedDate = [calendar dateFromComponents:components];

    self.dayNightView = [[DayNightView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.datePicker.frame.origin.y) time:[normalizedDate dateByAddingTimeInterval:60*60*8]];
    [self.view insertSubview:self.dayNightView belowSubview:self.datePicker];

    self.datePicker.hidden = YES;
    self.buttonBackground.hidden = YES;
    self.dayNightView.hidden = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(checkAlarmTime)
                                   userInfo:nil
                                    repeats:YES];
    
    if ([DefaultsHelper alarmDate]) {
        [self.button setTitle:@"Cancel Alarm" forState:UIControlStateNormal];
        [self.buttonBackground setBackgroundColor:[UIColor colorWithRed:254/255.0 green:115/255.0 blue:115/255.0 alpha:1.0]];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self.datePicker setDate:[DefaultsHelper alarmDate] animated:NO];
        [self.dayNightView setDate:[DefaultsHelper alarmDate] animated:NO];
    }
    else {
        [self.button setTitle:@"Set Alarm" forState:UIControlStateNormal];
        [self.buttonBackground setBackgroundColor:[UIColor whiteColor]];
        [self.button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        [self.datePicker setDate:[normalizedDate dateByAddingTimeInterval:60*60*8] animated:NO];
        [self.dayNightView setDate:[normalizedDate dateByAddingTimeInterval:60*60*8] animated:NO];
    }
}

- (void)tweet
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.audioPlayer stop];
        
        [DefaultsHelper setTweetDate:nil];
        
        TWTRAPIClient *client = [[Twitter sharedInstance]APIClient];
        
        //Build the request that you want to launch using the API and the text to be tweeted.
        NSURLRequest *tweetRequest = [client URLRequestWithMethod:@"POST" URL:@"https://api.twitter.com/1.1/statuses/update.json" parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"I slept in again :/ #RollOut", @"status", nil] error:nil];
        
        //Perform this whenever you need to perform the tweet (REST API call)
        [client sendTwitterRequest:tweetRequest completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            //Check for the response and update UI according if necessary.
            
            NSLog(@"%@", response);
        }];
        
        
        UIImageView *chatBubble = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 285, 202)];
        [chatBubble setImage:[UIImage imageNamed:@"chat_left.png"]];
        [self.view addSubview:chatBubble];
        chatBubble.center = CGPointMake(self.view.center.x, -200);
        chatBubble.alpha = 0.0;
        UITextView *textView2 = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, chatBubble.frame.size.width - 40, chatBubble.frame.size.height - 40)];
        [textView2 setFont:[UIFont fontWithName:@"Avenir" size:24]];
        [textView2 setTextColor:[UIColor darkGrayColor]];
        textView2.backgroundColor = [UIColor clearColor];
        textView2.userInteractionEnabled = NO;
        [textView2 setText:@"I slept in again :/ #RollOut"];
        [chatBubble addSubview:textView2];
        
        [UIView animateWithDuration:.6 delay:.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            chatBubble.center = CGPointMake(self.view.center.x, (chatBubble.frame.size.height / 2) + 30);
            chatBubble.alpha = 1.0;

        } completion:^(BOOL finished) {
        
            [UIView animateWithDuration:.6 delay:5.8 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                chatBubble.center = CGPointMake(self.view.center.x, -200);
                chatBubble.alpha = 0.0;

            } completion:^(BOOL finished) {
                
                [chatBubble removeFromSuperview];
                
            }];

        }];
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.datePicker.hidden = YES;
    self.buttonBackground.hidden = YES;
    self.dayNightView.hidden = YES;

    if (![DefaultsHelper introShown]) {
        [self performSegueWithIdentifier:@"Intro" sender:self];
    }
    else if (![[Twitter sharedInstance] session]) {
        [self performSegueWithIdentifier:@"Account" sender:self];
    }
    else {
        self.datePicker.hidden = NO;
        self.buttonBackground.hidden = NO;
        self.dayNightView.hidden = NO;
    }
}

- (IBAction)buttonSelected:(id)sender
{
    if ([self.button.titleLabel.text isEqualToString:@"Cancel Alarm"])
    {
        [self setAlarmTime:nil];
    }
    else {
        [self setAlarmTime:[self nextDateFromDatePickerTime:self.datePicker.date]];
    }
}

- (void)checkAlarmTime
{
    if ([DefaultsHelper alarmDate]) {
        if ([[DefaultsHelper alarmDate] timeIntervalSinceNow] < 0.0) {
            [self initiateWakeUpSequence];
        }
    }
    else if ([DefaultsHelper tweetDate]) {
        if ([[DefaultsHelper tweetDate] timeIntervalSinceNow] < 0.0) {
            [self tweet];
        }
    }

}

- (IBAction)datePickerValueChanged:(id)sender
{
    [self.dayNightView setDate:self.datePicker.date animated:YES];
    [self setAlarmTime:nil];
}

- (NSDate *)nextDateFromDatePickerTime:(NSDate *)date
{
    if ([date timeIntervalSinceNow] < 0.0) {
        date = [date dateByAddingTimeInterval:60 * 60 * 24];
    }
    return date;
}

- (void)setAlarmTime:(NSDate *)date
{
    [DefaultsHelper setAlarmDate:date];
    
    if (date) {
        [self.button setTitle:@"Cancel Alarm" forState:UIControlStateNormal];
        [self.buttonBackground setBackgroundColor:[UIColor colorWithRed:254/255.0 green:115/255.0 blue:115/255.0 alpha:1.0]];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    else {
        [self.button setTitle:@"Set Alarm" forState:UIControlStateNormal];
        [self.buttonBackground setBackgroundColor:[UIColor whiteColor]];
        [self.button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}

- (void)initiateWakeUpSequence
{
    [self setAlarmTime:nil];
    
    [DefaultsHelper setTweetDate:[[NSDate date] dateByAddingTimeInterval:60 * 5]];

    NSString *path = [NSString stringWithFormat:@"%@/sound.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];

    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.audioPlayer.numberOfLoops = -1;
    
    // Volume doesnt set loud enough...
    
    [self.audioPlayer setVolume:1.0];
    [self.audioPlayer play];
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    
    if (state == UIApplicationStateActive) {
        [self performSegueWithIdentifier:@"Scan" sender:nil];
    }
    else {
        self.shouldShowScan = YES;
    }
}

- (void)appBecameActive
{
    if (self.shouldShowScan) {
        self.shouldShowScan = NO;
        if ([DefaultsHelper tweetDate]) {
            [self performSegueWithIdentifier:@"Scan" sender:nil];
        }
    }
}

- (void)scanViewControllerDidFindBarcode:(ScanViewController *)scanViewController
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.audioPlayer stop];
        
        [DefaultsHelper setTweetDate:nil];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Scan"]) {
        ScanViewController *scanViewController = (ScanViewController *)segue.destinationViewController;
        scanViewController.delegate = self;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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

@interface ViewController () <ScanViewControllerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *alarmOnSwitch;

@end

@implementation ViewController

@synthesize audioPlayer = _audioPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(checkAlarmTime)
                                   userInfo:nil
                                    repeats:YES];
    
    if ([DefaultsHelper alarmDate]) {
        [self.alarmOnSwitch setOn:YES];
    }
    else {
        [self.alarmOnSwitch setOn:NO];
    }
    
    TWTRAPIClient *client = [[Twitter sharedInstance]APIClient];

    //Build the request that you want to launch using the API and the text to be tweeted.
    NSURLRequest *tweetRequest = [client URLRequestWithMethod:@"POST" URL:@"https://api.twitter.com/1.1/statuses/update.json" parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"TEXT TO BE TWEETED", @"status", nil] error:nil];
    
    //Perform this whenever you need to perform the tweet (REST API call)
    [client sendTwitterRequest:tweetRequest completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //Check for the response and update UI according if necessary.
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![DefaultsHelper introShown]) {
        [self performSegueWithIdentifier:@"Intro" sender:self];
    }
    else if (![[Twitter sharedInstance] session]) {
        [self performSegueWithIdentifier:@"Account" sender:self];
    }
    else {
        
    }
}

- (void)scanViewControllerDidFindBarcode:(ScanViewController *)scanViewController
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)checkAlarmTime
{
    if ([DefaultsHelper alarmDate]) {
        if ([[DefaultsHelper alarmDate] timeIntervalSinceNow] < 0.0) {
            [self initiateWakeUpSequence];
        }
    }
}

- (IBAction)datePickerValueChanged:(id)sender
{
    [self setAlarmTime:nil];
}

- (IBAction)alarmSwitchValueChanged:(id)sender
{
    if (self.alarmOnSwitch.isOn) {
        [self setAlarmTime:[self nextDateFromDatePickerTime:self.datePicker.date]];
    }
    else {
        [self setAlarmTime:nil];
    }
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
        [self.alarmOnSwitch setOn:YES animated:YES];
    }
    else {
        [self.alarmOnSwitch setOn:NO animated:YES];
    }
}

- (void)initiateWakeUpSequence
{
    [self setAlarmTime:nil];
    
    
    NSString *path = [NSString stringWithFormat:@"%@/sound.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];

    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    // Volume doesnt set loud enough...
    
    [self.audioPlayer setVolume:1.0];
    [self.audioPlayer play];
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

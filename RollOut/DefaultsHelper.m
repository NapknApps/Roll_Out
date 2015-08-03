//
//  DefaultsHelper.m
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "DefaultsHelper.h"

#define kIntroShown @"kIntroShown"
#define kAlarmDate @"kAlarmDate"
#define kTweetDate @"kTweetDate"

@implementation DefaultsHelper

+ (BOOL)introShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIntroShown];
}

+ (void)setIntroShown
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIntroShown];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate *)alarmDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAlarmDate];
}

+ (void)setAlarmDate:(NSDate *)alarmDate
{
    [[NSUserDefaults standardUserDefaults] setObject:alarmDate forKey:kAlarmDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate *)tweetDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kTweetDate];
}

+ (void)setTweetDate:(NSDate *)tweetDate
{
    [[NSUserDefaults standardUserDefaults] setObject:tweetDate forKey:kTweetDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

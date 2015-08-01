//
//  DefaultsHelper.h
//  NoMoJo
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultsHelper : NSObject

+ (BOOL)introShown;
+ (void)setIntroShown;

+ (NSDate *)alarmDate;
+ (void)setAlarmDate:(NSDate *)alarmDate;

@end

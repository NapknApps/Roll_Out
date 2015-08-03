//
//  DayNightView.h
//  RollOut
//
//  Created by Zach Whelchel on 8/1/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayNightView : UIView

- (id)initWithFrame:(CGRect)aRect time:(NSDate *)date;
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end

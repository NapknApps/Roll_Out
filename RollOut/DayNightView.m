//
//  DayNightView.m
//  RollOut
//
//  Created by Zach Whelchel on 8/1/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "DayNightView.h"

@interface DayNightView ()

@property (strong, nonatomic) UIImageView *sunImageView;
@property (strong, nonatomic) UIImageView *sunRay1ImageView;
@property (strong, nonatomic) UIImageView *sunRay2ImageView;
@property (strong, nonatomic) UIImageView *sunRay3ImageView;
@property (strong, nonatomic) UIImageView *moonImageView;

@end

@implementation DayNightView

- (id)initWithFrame:(CGRect)aRect time:(NSDate *)date
{
    self = [super initWithFrame:aRect];
    if (self)
    {
        self.sunImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
        [self.sunImageView setImage:[UIImage imageNamed:@"sun.png"]];
        [self addSubview:self.sunImageView];
        
        self.sunRay1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 176, 176)];
        [self.sunRay1ImageView setImage:[UIImage imageNamed:@"ray_1.png"]];
        [self addSubview:self.sunRay1ImageView];

        self.sunRay2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 388, 388)];
        [self.sunRay2ImageView setImage:[UIImage imageNamed:@"ray_2.png"]];
        [self addSubview:self.sunRay2ImageView];

        self.sunRay3ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 745, 745)];
        [self.sunRay3ImageView setImage:[UIImage imageNamed:@"ray_3.png"]];
        [self addSubview:self.sunRay3ImageView];
        
        self.moonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 71, 72)];
        [self.moonImageView setImage:[UIImage imageNamed:@"moon.png"]];
        [self addSubview:self.moonImageView];
        
        [self setDate:date animated:NO];
    }
    return self;
}

- (void)positionSunForPercentageThroughDay:(float)percentageOfDayDone
{
    if (percentageOfDayDone <= .5) {
        self.sunImageView.center = CGPointMake(self.frame.size.width - 70, self.frame.size.height - (self.frame.size.height * (percentageOfDayDone * 2)) + 70);
    }
    else if (percentageOfDayDone > .5) {
        self.sunImageView.center = CGPointMake(self.frame.size.width - 70, self.frame.size.height * (percentageOfDayDone * 2) - self.frame.size.height + 70);
    }
    self.sunImageView.alpha = 1.0 - (self.sunImageView.center.y / self.frame.size.height);
}

- (void)positionSunRay1ForPercentageThroughDay:(float)percentageOfDayDone
{
    if (percentageOfDayDone <= .5) {
        self.sunRay1ImageView.center = CGPointMake(self.frame.size.width - 70, self.frame.size.height - (self.frame.size.height * (percentageOfDayDone * 2)) + 70);
    }
    else if (percentageOfDayDone > .5) {
        self.sunRay1ImageView.center = CGPointMake(self.frame.size.width - 70, self.frame.size.height * (percentageOfDayDone * 2) - self.frame.size.height + 70);
    }
    self.sunRay1ImageView.alpha = 1.0 - (self.sunRay1ImageView.center.y / self.frame.size.height);
}

- (void)positionSunRay2ForPercentageThroughDay:(float)percentageOfDayDone
{
    if (percentageOfDayDone <= .5) {
        self.sunRay2ImageView.center = CGPointMake(self.frame.size.width - 70, self.frame.size.height - (self.frame.size.height * (percentageOfDayDone * 2)) + 70);
    }
    else if (percentageOfDayDone > .5) {
        self.sunRay2ImageView.center = CGPointMake(self.frame.size.width - 70, self.frame.size.height * (percentageOfDayDone * 2) - self.frame.size.height + 70);
    }
    self.sunRay2ImageView.alpha = 1.0 - (self.sunRay2ImageView.center.y / self.frame.size.height);
}

- (void)positionSunRay3ForPercentageThroughDay:(float)percentageOfDayDone
{
    if (percentageOfDayDone <= .5) {
        self.sunRay3ImageView.center = CGPointMake(self.frame.size.width - 70, self.frame.size.height - (self.frame.size.height * (percentageOfDayDone * 2)) + 70);
    }
    else if (percentageOfDayDone > .5) {
        self.sunRay3ImageView.center = CGPointMake(self.frame.size.width - 70, self.frame.size.height * (percentageOfDayDone * 2) - self.frame.size.height + 70);
    }
    self.sunRay3ImageView.alpha = 1.0 - (self.sunRay3ImageView.center.y / self.frame.size.height);
}

- (void)positionMoonForPercentageThroughDay:(float)percentageOfDayDone
{
    if (percentageOfDayDone <= .5) {
        self.moonImageView.center = CGPointMake(70, self.frame.size.height * (percentageOfDayDone * 2) + 70);
    }
    else if (percentageOfDayDone > .5) {
        self.moonImageView.center = CGPointMake(70, self.frame.size.height - (self.frame.size.height * ((percentageOfDayDone - .5) / .5)) + 70);
    }
    NSLog(@"%f %f", self.moonImageView.center.y, self.frame.size.height);
    self.moonImageView.alpha = 1.0 - (self.moonImageView.center.y / self.frame.size.height);
}


- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    int minutes = minute + (hour * 60);
    float percentageOfDayDone = minutes / (60 * 24.0);
    
    
    
    if (animated) {
        [UIView animateWithDuration:1.0 delay:.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self positionSunForPercentageThroughDay:percentageOfDayDone];
            [self positionMoonForPercentageThroughDay:percentageOfDayDone];
        } completion:^(BOOL finished) { }];
        
        [UIView animateWithDuration:1.3 delay:.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self positionSunRay1ForPercentageThroughDay:percentageOfDayDone];
        } completion:^(BOOL finished) { }];

        [UIView animateWithDuration:1.6 delay:.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self positionSunRay2ForPercentageThroughDay:percentageOfDayDone];
        } completion:^(BOOL finished) { }];

        [UIView animateWithDuration:2.0 delay:.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self positionSunRay3ForPercentageThroughDay:percentageOfDayDone];
        } completion:^(BOOL finished) { }];
    }
    else {
        
        [self positionSunForPercentageThroughDay:percentageOfDayDone];
        [self positionMoonForPercentageThroughDay:percentageOfDayDone];
        [self positionSunRay1ForPercentageThroughDay:percentageOfDayDone];
        [self positionSunRay2ForPercentageThroughDay:percentageOfDayDone];
        [self positionSunRay3ForPercentageThroughDay:percentageOfDayDone];

    }
    

    
    
}

@end

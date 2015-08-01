//
//  ScanViewController.h
//  RollOut
//
//  Created by Zach Whelchel on 8/1/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScanViewController;

@protocol ScanViewControllerDelegate

@required

- (void)scanViewControllerDidFindBarcode:(ScanViewController *)scanViewController;

@end

@interface ScanViewController : UIViewController

@property (nonatomic, weak) id <ScanViewControllerDelegate> delegate;

@end

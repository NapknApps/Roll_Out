//
//  AccountViewController.m
//  Envoyer
//
//  Created by Zach Whelchel on 7/24/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import "AccountViewController.h"
#import "DefaultsHelper.h"
#import <TwitterKit/Twitter.h>

@interface AccountViewController ()

@property (weak, nonatomic) IBOutlet UIView *twitterLogoBackgroundView;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
//        // play with Twitter session
//    }];
//    logInButton.center = self.view.center;
//    [self.view addSubview:logInButton];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, self.view.frame.size.height - 160)];
    
    [textView setFont:[UIFont fontWithName:@"Avenir" size:32]];
    [textView setTextColor:[UIColor whiteColor]];
    textView.backgroundColor = [UIColor clearColor];
    textView.userInteractionEnabled = YES;
    textView.editable = NO;

    [textView setText:@"When you set an alarm be sure to turn your volume up and don't leave the app (you can lock the screen). Sign in with the account that will tweet when you sleep in to get started. You've got this!"];
    [self.view addSubview:textView];

    
    
    
    self.twitterLogoBackgroundView.layer.cornerRadius = self.twitterLogoBackgroundView.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithTwitterSelected:(id)sender
{
    [[Twitter sharedInstance]logInWithCompletion:^(TWTRSession *session, NSError *error) {

        [self dismissViewControllerAnimated:NO completion:^{
            
        }];

    }];

    /*
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://envoyer.firebaseio.com"];
    TwitterAuthHelper *twitterAuthHelper = [[TwitterAuthHelper alloc] initWithFirebaseRef:ref
                                                                                   apiKey:@"rnXkB43O6DbEcmhEm4f3da2Y7"];
    [twitterAuthHelper selectTwitterAccountWithCallback:^(NSError *error, NSArray *accounts) {
        if (error) {
            // Error retrieving Twitter accounts
            
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"No Twitter Accounts Found"
                                                  message:@"Have you added your Twitter account in the iOS Settings app?"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               
                                           }];
            
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];

            
        } else if ([accounts count] == 0) {
            
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"No Twitter Accounts Found"
                                                  message:@"Have you added your Twitter account in the iOS Settings app?"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               
                                           }];
            
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];

            
            
            // No Twitter accounts found on device
        } else {
            // Select an account. Here we pick the first one for simplicity
            ACAccount *account = [accounts firstObject];
            
            
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Select a Twitter Account"
                                                  message:@"This is the account that will post your failure to wakeup."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            for (ACAccount *account in accounts) {
                UIAlertAction *accountAction = [UIAlertAction
                                               actionWithTitle:account.username
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   [twitterAuthHelper authenticateAccount:account withCallback:^(NSError *error, FAuthData *authData) {
                                                       if (error) {
                                                           // Error authenticating account
                                                       } else {
                                                           // User logged in!
                                                           
                                                           NSDictionary *info = @{@"twitter_handle" : [account username]};
                                                           [[FirebaseHelper userFirebaseReference] setValue:info];
                                                           
                                                           NSDictionary *info2 = @{@"twitter_handle" : [account username], @"uid": [[[FirebaseHelper baseFirebaseReference] authData] uid]};
                                                           [[[[FirebaseHelper baseFirebaseReference] childByAppendingPath:@"user-handles"] childByAppendingPath:[NSString stringWithFormat:@"%@", [[[FirebaseHelper baseFirebaseReference] authData] uid]]] setValue:info2];
                                                           
                                                           [DefaultsHelper setUserTwitterHandle:[account username]];
                                                           
                                                           
                                                           [self dismissViewControllerAnimated:NO completion:^{
                                                               
                                                           }];
                                                       }
                                                   }];
                                                   
                                               }];
                [alertController addAction:accountAction];
            }
            
            [self presentViewController:alertController animated:YES completion:nil];

            
            
            
            
            
            
        }
    }];
     */
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

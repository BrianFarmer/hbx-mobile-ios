//
//  ViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/4/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "KeychainItemWrapper.h"

@interface ViewController ()

@end

@implementation ViewController

- (UIImage *)resizeImage:(UIImage *)original
{
    // Calculate new size given scale factor.
    /*
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    // Calculate new size given scale factor.
    CGSize newSize = CGSizeMake(24.0f, 24.0f);

    
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        // Place iPhone/iPod specific code here...
        self.submitButton.frame = CGRectMake(20, self.submitButton.frame.origin.y, screenSize.width - 40, self.submitButton.frame.size.height);
        txtEmail.frame = CGRectMake(20, txtEmail.frame.origin.y, screenSize.width - 40, txtEmail.frame.size.height);
        txtPassword.frame = CGRectMake(20, txtPassword.frame.origin.y, screenSize.width - 40, txtPassword.frame.size.height);
        self.enableTouchIdButton.frame = CGRectMake(screenSize.width - 160, self.enableTouchIdButton.frame.origin.y, 24, self.enableTouchIdButton.frame.size.height);
        lblEnableTouchID.frame = CGRectMake(self.enableTouchIdButton.frame.origin.x + 29, lblEnableTouchID.frame.origin.y, screenSize.width - 40, lblEnableTouchID.frame.size.height);
        lblDisclaimer.frame = CGRectMake(20, lblDisclaimer.frame.origin.y, screenSize.width - 40, lblDisclaimer.frame.size.height);
    } else {
        // Place iPad-specific code here...
        self.submitButton.frame = CGRectMake(screenSize.width /2 - 100, self.submitButton.frame.origin.y, 200, self.submitButton.frame.size.height);
    }
    
    UIImage *btnImage = [self resizeImage:[UIImage imageNamed:@"checkbox.png"]];
    [self.enableTouchIdButton setImage:btnImage forState:UIControlStateNormal];
    [self.saveUserInfoButton setImage:btnImage forState:UIControlStateNormal];
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"DCHLApp"  accessGroup:nil];
    
    NSString *password = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrLabel];
    //    [keychainItem setObject:@"password" forKey:(__bridge id)kSecAttrAccount];
    //  [keychainItem setObject:@"dboyd5@@hotmail.com" forKey:(__bridge id)kSecAttrLabel];
    // Get the stored data before the view loads
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //    NSString *sSaveUser = [defaults objectForKey:@"saveUser"];
    //    NSString *sEnableTouchID = [defaults objectForKey:@"enableTouchID"];
    UIImageView *pView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, screenSize.width, 60)];
    pView.backgroundColor = [UIColor whiteColor];
    pView.image = [UIImage imageNamed:@"dchealthlink.jpg"];
    pView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:pView];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"saveUserInfo"])
    {
        txtEmail.text = username;
//        txtPassword.text = password;
        
        bSaveUserInfo = true;
        [self.saveUserInfoButton setImage:[self resizeImage:[UIImage imageNamed:@"checkbox-checked.png"]] forState:UIControlStateNormal];
        
        bUseTouchID = [[NSUserDefaults standardUserDefaults] boolForKey:@"useTouchID"];
        if (bUseTouchID)
            [self.enableTouchIdButton setImage:[self resizeImage:[UIImage imageNamed:@"checkbox-checked.png"]] forState:UIControlStateNormal];
        
        
    }
//    bUseTouchID = true;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleButtonClick:(id)sender
{
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
                [self performSegueWithIdentifier:@"Show My Account" sender:nil];
#if !(TARGET_IPHONE_SIMULATOR)
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if( [txtEmail.text caseInsensitiveCompare:@"john@dc.gov"] == NSOrderedSame )        //For DEMO Only
    {
        // strings are equal except for possibly case
        if( [txtPassword.text isEqualToString:@"password"] ) {
            if (bSaveUserInfo)
            {
                KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"DCHLApp"  accessGroup:nil];
                [keychainItem setObject:@"password" forKey:(__bridge id)kSecAttrAccount];
                [keychainItem setObject:txtEmail.text forKey:(__bridge id)kSecAttrLabel];
                //   [keychainItem setObject:@"" forKey:(__bridge id)kSecAttrDescription];
                
            }
            else
            {
                //delete information
            }
            
            [[NSUserDefaults standardUserDefaults] setBool:bSaveUserInfo forKey:@"saveUserInfo"];
            [[NSUserDefaults standardUserDefaults] setBool:bUseTouchID forKey:@"useTouchID"];

            [self performSegueWithIdentifier:@"Show My Account" sender:nil];
 //               [self performSegueWithIdentifier:@"Select Plan Employee" sender:nil];
        }
        
    }
#else
//    [self performSegueWithIdentifier:@"Show My Account" sender:nil];
//    [self performSegueWithIdentifier:@"Select Plan Employee" sender:nil];
    [self performSegueWithIdentifier:@"Show My Account" sender:nil];
#endif
}

- (IBAction)saveUserInfoButton:(id)sender {
    UIImage *btnImage;
    
    if (bSaveUserInfo)
    {
        btnImage = [self resizeImage:[UIImage imageNamed:@"checkbox.png"]];
        
        bSaveUserInfo = false;
    }
    else
    {
        btnImage = [self resizeImage:[UIImage imageNamed:@"checkbox-checked.png"]];
        
        bSaveUserInfo = true;
    }
    
    [self.saveUserInfoButton setImage:btnImage forState:UIControlStateNormal];
}

- (IBAction)enableTouchIdButton:(id)sender {
    UIImage *btnImage;
    
    if (bUseTouchID)
    {
        btnImage = [self resizeImage:[UIImage imageNamed:@"checkbox.png"]];
        
        bUseTouchID = false;
    }
    else
    {
        btnImage = [self resizeImage:[UIImage imageNamed:@"checkbox-checked.png"]];
        
        bUseTouchID = true;
    }
    
    [self.enableTouchIdButton setImage:btnImage forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
#if !(TARGET_IPHONE_SIMULATOR)
    if (bUseTouchID)
    {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        NSString *myLocalizedReasonString = @"Touch ID Test to show Touch ID working in a custom app";
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:myLocalizedReasonString
                                reply:^(BOOL success, NSError *error) {
                                    if (success) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self performSegueWithIdentifier:@"Show My Account" sender:nil];
                                            //  lblStatus.text = @"You have logged in with Touch ID";
                                        });
                                    } else {
                                        /*
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                         message:error.description
                                         delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
                                         [alertView show];
                                         NSLog(@"Switch to fall back authentication - ie, display a keypad or password entry box");
                                         });
                                         */
                                    }
                                }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:authError.description
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                // Commented this out if touchid is not enabled.
                // Maybe add some code to ask or something
                //                [alertView show];
            });
        }
    }
#endif
}

@end

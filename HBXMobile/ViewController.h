//
//  ViewController.h
//  HBXMobile
//
//  Created by David Boyd on 3/4/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UILabel *lblDisclaimer;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
//    IBOutlet UIButton *submitButton;
    IBOutlet UILabel *lblEnableTouchID;
    IBOutlet UILabel *lblSaveUserID;
    IBOutlet UIView *bottomView;
    IBOutlet UIView *topView;
    IBOutlet UISwitch *switchTouchId;
    IBOutlet UISwitch *switchSaveMe;
    
    UIActivityIndicatorView *spinningWheel;
    
    BOOL bSaveUserInfo;
    BOOL bUseTouchID;
    
    NSString *responseString;
}

@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *enableTouchIdButton;
@property (strong, nonatomic) IBOutlet UIButton *saveUserInfoButton;
//@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinningWheel;

@end


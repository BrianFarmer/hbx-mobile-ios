//
//  ViewController.h
//  HBXMobile
//
//  Created by David Boyd on 3/4/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mapkit/mapkit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
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
    
    IBOutlet UILabel *lblVersion;
    
    NSString *csrfToken;
    NSString *customCookie;
    NSString *customCookie_a;
    NSMutableData *_responseData;
    
    NSURLConnection *conn;
    
    NSString *_brokerId;
    
    int REQUEST_TYPE;
    BOOL reLoad;
}

@property (strong, nonatomic) IBOutlet UIButton *submitButton;
//@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinningWheel;
@property(nonatomic, retain) CLLocationManager *locationManager;

@end


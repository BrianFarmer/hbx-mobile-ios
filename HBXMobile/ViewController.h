//
//  ViewController.h
//  HBXMobile
//
//  Created by David Boyd on 3/4/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mapkit/mapkit.h>

#define kReloadJSON @"ApplicationRefreshingTableData"
#define GET_BROKER_ID           1000
#define GET_BROKER_EMPLOYERS    1001
#define INITIAL_GET             1002
#define POST_LOGIN_DONE         1003
#define INITIAL_LOGIN_NS        1004
#define IS_SECURITY_VALID       1005

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    IBOutlet UILabel                *lblDisclaimer;
    IBOutlet UITextField            *txtEmail;
    IBOutlet UITextField            *txtPassword;
    IBOutlet UILabel                *lblEnableTouchID;
    IBOutlet UILabel                *lblSaveUserID;
    IBOutlet UIView                 *bottomView;
    IBOutlet UIView                 *topView;
    IBOutlet UISwitch               *switchTouchId;
    IBOutlet UISwitch               *switchSaveMe;
    IBOutlet UILabel                *lblVersion;
    
    UIActivityIndicatorView *spinningWheel;

    BOOL bSaveUserInfo;
    BOOL bUseTouchID;
    
    NSString *responseString;
    
    NSString *enrollHost;
    NSString *mobileHost;
    
    NSString *securityQuestion;
    NSString *csrfToken;
    NSString *customCookie;
    NSString *customCookie_a;
    NSMutableData *_responseData;
    
    NSURLConnection *conn;
    
    NSString *_brokerId;
    NSString *sFirstName;
    
    int REQUEST_TYPE;
    BOOL reLoad;
    
    UILabel* lblDB;
}

@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property(nonatomic, retain) CLLocationManager *locationManager;

@end


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
#import "LeftMenuSlideOutTableViewController.h"
#import "BrokerAccountTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Settings.h"


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController ()

@end

@implementation ViewController

- (UIImage *)resizeImage:(UIImage *)original
{
    // Calculate new size given scale factor.
    CGSize newSize = CGSizeMake(24.0f, 24.0f);

    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)viewWillLayoutSubviews
{
//    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        
    }
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIColor *color = [UIColor whiteColor];
        txtEmail.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:@"Email Address"
         attributes:@{NSForegroundColorAttributeName:color}];
        
        txtPassword.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:@"Password"
         attributes:@{NSForegroundColorAttributeName:color}];
 
        txtPassword.tintColor = [UIColor whiteColor];
        
        int scaleWidth;
        
        if (self.view.frame.size.width <= 320)
            scaleWidth = 250;
        else
            scaleWidth = 300;
        
        int iStart = self.view.frame.size.height;
        if (self.view.frame.size.height > 600)
        {
            if (self.view.frame.size.height > 700)
                iStart = 250;
            else
                iStart = 250;
        }
        else
            iStart = 200;

        bottomView.frame = CGRectMake(self.view.frame.size.width / 2 - 90, self.view.frame.size.height - iStart, 180, 170);// submitButton.frame.origin.y +
        
       // bottomView.frame = CGRectMake(0, self.view.frame.size.height - iStart, self.view.frame.size.width, 170);// submitButton.frame.origin.y + submitButton.frame.size.height + 10, 300, 200);
        lblDisclaimer.frame = CGRectMake(0, 0, 180, 204);

        submitButton.frame = CGRectMake(self.view.frame.size.width / 2 - scaleWidth/2, bottomView.frame.origin.y - 44, scaleWidth, 44);
        
        lblSaveUserID.frame = CGRectMake(submitButton.frame.origin.x, submitButton.frame.origin.y - 70, 150, 40);
        switchSaveMe.frame = CGRectMake(submitButton.frame.origin.x + scaleWidth - switchSaveMe.frame.size.width, lblSaveUserID.frame.origin.y + 5, switchSaveMe.frame.size.width, 40);

        BOOL hasTouchID = NO;
        
        if ([LAContext class]) {
            LAContext *context = [LAContext new];
            NSError *error = nil;
            hasTouchID = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
            
            if (hasTouchID)
            {
                lblEnableTouchID.frame = CGRectMake(submitButton.frame.origin.x, lblSaveUserID.frame.origin.y - 50, 150, 40);
                switchTouchId.frame = CGRectMake(submitButton.frame.origin.x + scaleWidth - switchTouchId.frame.size.width, lblEnableTouchID.frame.origin.y + 5, switchTouchId.frame.size.width, 40);
            }
        }
        
        if (hasTouchID)
            txtPassword.frame = CGRectMake(submitButton.frame.origin.x, lblEnableTouchID.frame.origin.y - 65, scaleWidth, 40);
        else
            txtPassword.frame = CGRectMake(submitButton.frame.origin.x, lblSaveUserID.frame.origin.y - 80, scaleWidth, 40);
        
        txtEmail.frame = CGRectMake(submitButton.frame.origin.x, txtPassword.frame.origin.y - 60, scaleWidth, 40);

/*
        txtEmail.frame = CGRectMake(iLeftPos, 200, 300, 40);
        txtPassword.frame = CGRectMake(iLeftPos, 260, 300, 40);
 lblEnableTouchID.frame = CGRectMake(iLeftPos, txtPassword.frame.origin.y + txtPassword.frame.size.height + 20, 150, 40);
 switchTouchId.frame = CGRectMake(iLeftPos + 300 - switchTouchId.frame.size.width, lblEnableTouchID.frame.origin.y + 5, switchTouchId.frame.size.width, 40);
        lblSaveUserID.frame = CGRectMake(iLeftPos, lblEnableTouchID.frame.origin.y + lblEnableTouchID.frame.size.height + 20, 150, 40);
        switchSaveMe.frame = CGRectMake(iLeftPos + 300 - switchSaveMe.frame.size.width, lblSaveUserID.frame.origin.y + 5, switchSaveMe.frame.size.width, 40);
*/
        
        switchTouchId.thumbTintColor = [UIColor whiteColor];
        switchTouchId.tintColor = [UIColor whiteColor];
        
        [switchSaveMe setThumbTintColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]];
        
        switchSaveMe.thumbTintColor = [UIColor whiteColor];
        switchSaveMe.tintColor = [UIColor whiteColor];
        switchSaveMe.layer.cornerRadius = 16;
        switchSaveMe.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];

        if (self.view.frame.size.width <= 320)
            pLogoOnTop.frame = CGRectMake(self.view.frame.size.width/2-250/2, 25, 250, 250 * .333);
        else
            pLogoOnTop.frame = CGRectMake(self.view.frame.size.width/2-300/2, 35, 300, 300 * .333);
        
        CALayer *border = [CALayer layer];
        CGFloat borderWidth = 1;
        border.borderColor = [UIColor whiteColor].CGColor;
        border.frame = CGRectMake(0, txtEmail.frame.size.height - borderWidth, txtEmail.frame.size.width, txtEmail.frame.size.height);
        border.borderWidth = borderWidth;
        [txtEmail.layer addSublayer:border];
        txtEmail.layer.masksToBounds = YES;
        
        CALayer *border1 = [CALayer layer];
        border1.borderColor = [UIColor whiteColor].CGColor;
        border1.frame = CGRectMake(0, txtPassword.frame.size.height - borderWidth, txtPassword.frame.size.width, txtPassword.frame.size.height);
        border1.borderWidth = borderWidth;
        [txtPassword.layer addSublayer:border1];
        txtPassword.layer.masksToBounds = YES;
        
        lblVersion.numberOfLines = 1;
        lblVersion.frame = CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 25, 70, 15);
        lblVersion.text = [NSString stringWithFormat:@"v %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
//    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showbrokeremployers) name:kReloadJSON object:nil];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    spinningWheel = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinningWheel.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    spinningWheel.center = self.view.center;
    spinningWheel.layer.cornerRadius = 05;
    spinningWheel.opaque = NO;
    spinningWheel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];

    [self.view addSubview:spinningWheel];
    
    BOOL hasTouchID = NO;
    // if the LAContext class is available
    if ([LAContext class]) {
        LAContext *context = [LAContext new];
        NSError *error = nil;
        hasTouchID = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
        
        if (!hasTouchID)
        {
            [lblEnableTouchID setHidden:TRUE];
            [switchTouchId setHidden:TRUE];
        }
        else
            [switchTouchId addTarget: self action: @selector(enableTouchIdSwitch:) forControlEvents:UIControlEventValueChanged];

    }
    
    if (screenSize.height < 600)
        lblDisclaimer.font = [UIFont fontWithName:@"Roboto-Regular" size:12.0];

/***************************
 ***************************
 10-11-16
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600)
    {
        // Place iPhone/iPod specific code here...
        topView.frame = CGRectMake(25, 135, screenSize.width - 45, 330);
        
        submitButton.frame = CGRectMake(20, 265, screenSize.width - 80, 44);
        txtEmail.frame = CGRectMake(20, txtEmail.frame.origin.y, topView.frame.size.width - 40, 40);
        txtPassword.frame = CGRectMake(20, txtEmail.frame.origin.y + txtEmail.frame.size.height + 20, topView.frame.size.width - 40, 40);
        lblEnableTouchID.frame = CGRectMake(20, txtPassword.frame.origin.y + txtPassword.frame.size.height + 20, 150, 40);
        switchTouchId.frame = CGRectMake(topView.frame.origin.x + topView.frame.size.width - switchTouchId.frame.size.width - 40, lblEnableTouchID.frame.origin.y + 5, switchTouchId.frame.size.width, 40);
        lblSaveUserID.frame = CGRectMake(20, lblEnableTouchID.frame.origin.y + lblEnableTouchID.frame.size.height + 20, 150, 40);
        switchSaveMe.frame = CGRectMake(topView.frame.origin.x + topView.frame.size.width - switchSaveMe.frame.size.width - 40, lblSaveUserID.frame.origin.y + 5, switchSaveMe.frame.size.width, 40);
        bottomView.frame = CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y + 60, screenSize.width, screenSize.height - (bottomView.frame.origin.y + 60));
        lblDisclaimer.frame = CGRectMake(screenSize.width / 2 - 90, 80, 180, 204);
    }
    else
    {
        
    }
    
    lblVersion.numberOfLines = 3;
    lblVersion.lineBreakMode = NSLineBreakByWordWrapping;
    lblVersion.frame = CGRectMake(bottomView.frame.size.width - 50, bottomView.frame.size.height - 30, 70, 15);
    lblVersion.text = [NSString stringWithFormat:@"v %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    if (!PRODUCTION_BUILD)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, screenSize.height - 36, 32, 32)];
        UIImage *img = [UIImage imageNamed:@"gear.png"];
        [btn setImage:img forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showConfig:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    lblDB = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width /2 - 100, screenSize.height - 14, 200, 10)];
    lblDB.textAlignment = NSTextAlignmentCenter;
    lblDB.font = [UIFont systemFontOfSize:10];
    lblDB.textColor = [UIColor whiteColor];
    [self.view addSubview:lblDB];
    

    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(22, txtEmail.frame.origin.y + txtEmail.frame.size.height + 10, topView.frame.size.width - 22, 1)];
    separator.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [topView addSubview:separator];
    
    UIView * separator1 = [[UIView alloc] initWithFrame:CGRectMake(22, txtPassword.frame.origin.y + txtPassword.frame.size.height + 10, topView.frame.size.width - 22, 1)];
    separator1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [topView addSubview:separator1];
    
    UIView * separator2 = [[UIView alloc] initWithFrame:CGRectMake(22, lblEnableTouchID.frame.origin.y + lblEnableTouchID.frame.size.height + 10, topView.frame.size.width - 22, 1)];
    separator2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [topView addSubview:separator2];
*/
    
    if (!PRODUCTION_BUILD)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 36, 32, 32)];
        UIImage *img = [UIImage imageNamed:@"gear.png"];
        [btn setImage:img forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showConfig:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        lblDB = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2 - 100, self.view.frame.size.height - 20, 200, 15)];
        lblDB.textAlignment = NSTextAlignmentCenter;
        lblDB.font = [UIFont systemFontOfSize:10];
        lblDB.textColor = [UIColor whiteColor];
        [self.view addSubview:lblDB];
    }

    submitButton.layer.cornerRadius = 10;
    submitButton.clipsToBounds = YES;
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"DCHLApp"  accessGroup:nil];
    
//    NSString *password = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrLabel];
    //  [keychainItem setObject:@"password" forKey:(__bridge id)kSecAttrAccount];
    //  [keychainItem setObject:@"dboyd5@@hotmail.com" forKey:(__bridge id)kSecAttrLabel];

    int logoWidth;
    
    if (screenSize.height < 600)
        logoWidth = 200;
    else
        logoWidth = 300;
    
    pLogoOnTop = [[UIImageView alloc] initWithFrame:CGRectMake(screenSize.width/2-logoWidth/2, 25, logoWidth, logoWidth * .333)];
//    UIImageView *pView = [[UIImageView alloc] initWithFrame:CGRectMake(screenSize.width/2-100, 50, 200, 45)];
    pLogoOnTop.backgroundColor = [UIColor clearColor];
    pLogoOnTop.image = [self imageWithImage:[UIImage imageNamed:@"BrokerMVP_AppHeader512x147.png"] scaledToSize:CGSizeMake(300, 86)];
//    pLogoOnTop.image = [UIImage imageNamed:@"BrokerMVP_AppHeader512x147.png"];
    
    pLogoOnTop.contentMode =  UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:pLogoOnTop];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"saveUserInfo"])
    {
        txtEmail.text = username;
        
        switchSaveMe.on = TRUE;
        bSaveUserInfo = TRUE;
        
        bUseTouchID = [[NSUserDefaults standardUserDefaults] boolForKey:@"useTouchID"];
        if (bUseTouchID)
            switchTouchId.on = TRUE;
    }
    else
    {
        switchSaveMe.on = FALSE;
        switchTouchId.on = FALSE;
        
        bSaveUserInfo = FALSE;
        bUseTouchID = FALSE;
    }
    
    /**************************************/
    /**** USED TO REMOVE KEYBOARD *********/
    /**** BY SELECTING SOMEWHERE  *********/
    /**** ON SCREEN               *********/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    Settings *obj=[Settings getInstance];
    obj.iPlanVersion = 1;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)viewWillAppear:(BOOL)animated
{
    REQUEST_TYPE = 0;
    reLoad = FALSE;
    customCookie_a = @"";
    customCookie = @"";
    csrfToken = @"";
    
    [spinningWheel stopAnimating];
    
    self.navigationController.navigationBarHidden = YES;
#if (!PRODUCTION_BUILD)
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"whichServer"] intValue] == 1001)
        lblDB.text = @"using enroll database server";
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"whichServer"] intValue] == 1002)
        lblDB.text = @"using mobile notification server";
    else
        lblDB.text = @"using github for broker data";
#endif
    
#if !(TARGET_IPHONE_SIMULATOR)
    if (bUseTouchID)
    {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        
        NSString *stemp = txtEmail.text;
        
        stemp = [stemp stringByReplacingCharactersInRange:NSMakeRange(4, [stemp length]-4) withString:@"****"];
        NSLog(@"%@",stemp);

        NSString *myLocalizedReasonString = [NSString stringWithFormat:@"Sign in as %@", stemp];
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:myLocalizedReasonString
                                reply:^(BOOL success, NSError *error) {
                                    if (success) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                      //      [self performSegueWithIdentifier:@"Broker View 1" sender:nil];
                                            [self handleButtonClick:nil];
                                        });
                                    } else {
                                        
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                         NSLog(@"Switch to fall back authentication - ie, display a keypad or password entry box");
                                         });
                                    }
                                }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"TouchID not enabled");
            });
        }
    }
#endif
}

-(void)showConfig:(id)sender
{
    [self performSegueWithIdentifier:@"Config View" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchSaveUserChange:(UISwitch *)sender
{
    if (sender.on) {
        NSLog(@"If body ");
//        [sender setThumbTintColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]];
 //       [sender setBackgroundColor:[UIColor whiteColor]];
 //       [sender setOnTintColor:[UIColor greenColor]];
    //     [sender setThumbTintColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]];
    //    [switchSaveMe setOn:YES animated:NO];
        
    }else{
        NSLog(@"Else body ");
        
        //       switchTouchId.onTintColor = [UIColor redColor];

  //      sender.layer.cornerRadius = 16;
 //       [sender setTintColor:[UIColor greenColor]];
//        [sender setThumbTintColor:[UIColor whiteColor]];
    //    [sender setBackgroundColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]];
    }
}

- (IBAction)enableTouchIdSwitch:(id)sender {
    if (switchTouchId.on)
    {
        NSLog(@"On");
        switchSaveMe.on = TRUE;
        switchSaveMe.enabled = FALSE;
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Enable Touch ID"
                                              message:@"Touch ID will be enabled after you log in."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else
    {
        NSLog(@"Off");
        bUseTouchID = FALSE;
        switchSaveMe.enabled = TRUE;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:switchTouchId.isOn forKey:@"useTouchID"];
}

- (IBAction)handleButtonClick:(id)sender
{
    [self customActivityView];
    [loading setHidden:FALSE];
    loadLabel.text = @"Loading";
    
    iServerType = [[[NSUserDefaults standardUserDefaults] stringForKey:@"whichServer"] intValue];
    if (PRODUCTION_BUILD)
    {
        iServerType = 1002;
    }
    else
    {
        if (iServerType == 1001)
        {
            if ([txtEmail.text length] == 0)
            {
                txtEmail.text = @"bill.murray@example.com";
                txtPassword.text = @"Test123!";
            }
        }

        if (iServerType == 1002)
        {
            if ([txtEmail.text length] == 0)
            {
                txtEmail.text = @"seth.rollins@yopmail.com";
                txtPassword.text = @"$RFde3#1!87";
            }
        }
        
        if (iServerType == 1003 || iServerType == 0)
        {
            if ([txtEmail.text length] == 0)
            {
                txtEmail.text = @"githubuser@github.com";
                txtPassword.text = @"Test4Github";
            }
        }
    }
    
    if (switchSaveMe.isOn)
    {
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"DCHLApp"  accessGroup:nil];
//        [keychainItem setObject:@"password" forKey:(__bridge id)kSecAttrAccount];
        [keychainItem setObject:txtEmail.text forKey:(__bridge id)kSecAttrLabel];
        //   [keychainItem setObject:@"" forKey:(__bridge id)kSecAttrDescription];
    }
    else
    {
        //delete information
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:switchSaveMe.isOn forKey:@"saveUserInfo"];
    [[NSUserDefaults standardUserDefaults] setBool:switchTouchId.isOn forKey:@"useTouchID"];

    
    switch(iServerType)
    {
        case 1001:
            enrollHost = [[NSUserDefaults standardUserDefaults] stringForKey:@"enrollServer"];
            if (![enrollHost hasPrefix:@"http://"] && ![enrollHost hasPrefix:@"https://"])
            {
                enrollHost = [NSString stringWithFormat:@"http://%@", enrollHost];
            }
            
            [self login:enrollHost type:INITIAL_GET url:[NSString stringWithFormat:@"%@/users/sign_in", enrollHost]];
            break;
        case 1002:
    //        txtEmail.text = @"bobby.heenan@yopmail.com";
#if (PRODUCTION_BUILD)
            mobileHost = @"hbx-mobile.dchbx.org";
#else
            mobileHost = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobileServer"];

#endif
            if (![mobileHost hasPrefix:@"http://"] && ![mobileHost hasPrefix:@"https://"])
            {
                mobileHost = [NSString stringWithFormat:@"https://%@", mobileHost];
            }

            [self MOBILE_SERVER_Login:[NSString stringWithFormat:@"%@/login", mobileHost] host:mobileHost];
            break;
        case 1003:
        default:
            {
//                #if (TARGET_IPHONE_SIMULATOR)
                    if (switchTouchId.on)
                        bUseTouchID = TRUE;
                
                    [loading setHidden:TRUE];
                    [self performSegueWithIdentifier:@"BrokerTable" sender:nil];
//                #else
//                    [self askSecurityQuestion:FALSE];
//                #endif
            }
            break;
    }
}

-(void)askSecurityQuestion:(BOOL)bIncorrect
{
    UIAlertController *alertController = nil;
    
    alertController = [UIAlertController  alertControllerWithTitle:@"Security Question"
                                          message:@"What is your favorite color?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Enter you answer here", @"Login");
     }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       //[spinningWheel stopAnimating];
                                           [loading setHidden:TRUE];
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   UITextField *login = alertController.textFields.firstObject;
                                   if ([login.text caseInsensitiveCompare:@"Blue"] == NSOrderedSame)
                                       [self performSegueWithIdentifier:@"BrokerTable" sender:nil];
                                   else
                                       [self askSecurityQuestion:TRUE];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [alertController.view setNeedsLayout];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)percentEscapeURLParameter:(NSString *)string
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (CFStringRef)string,
                                                                     NULL,
                                                                     (CFStringRef)@":/?@!$&'()*+,;=",
                                                                     kCFStringEncodingUTF8));
}

//ONLY NEEDED FOR ENROLL LOGIN DIRECTLY
- (void)clearCookiesForURL {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/sign_in", enrollHost]]];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"Deleting cookie for domain: %@", [cookie domain]);
        [cookieStorage deleteCookie:cookie];
    }
}

-(void)MOBILE_SERVER_Login:(NSString*)pUrl host:(NSString*)host
{
                    methodStart = [NSDate date];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *post;
    
//    NSString *post = [NSString stringWithFormat:@"userid=%@&pass=$RFde3#1!87", @"bobby.heenan@yopmail.com"]; //seth.rollins@yopmail.com
    if (bUseTouchID && [txtPassword.text length] == 0)
    {
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"DCHLApp"  accessGroup:nil];
        szPassword = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    }
    else
        szPassword = txtPassword.text;

    post = [NSString stringWithFormat:@"userid=%@&pass=%@", txtEmail.text, szPassword]; //seth.rollins@yopmail.com

    NSLog(@"%@", @"\r\r\rLOGIN\r\r\r\r");
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; //NSASCIIStringEncoding
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setURL:[NSURL URLWithString:pUrl]];
    
    NSURL *candidateURL = [NSURL URLWithString:pUrl];
    // WARNING > "test" is an URL according to RFCs, being just a path
    // so you still should check scheme and all other NSURL attributes you need
    NSLog(@"%@", candidateURL.host);
    NSLog(@"%@", candidateURL.scheme);
    
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        // candidate is a well-formed url with:
        //  - a scheme (like http://)
        //  - a host (like stackoverflow.com)
        sSecurityQuestionLocationHost = [NSString stringWithFormat:@"%@://%@", candidateURL.scheme, candidateURL.host];
    }

    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody:postData];
    
    NSLog(@"%@", [request allHTTPHeaderFields]);
    
    //    customCookie_a = customCookie;
    
    REQUEST_TYPE = MOBILE_POST_LOGIN_DONE;
    
//    [NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:host];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

- (IBAction)login:(NSString *)host type:(int)requestType url:(NSString*)pUrl
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self clearCookiesForURL];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setURL:[NSURL URLWithString:pUrl]];
    
    [request setHTTPMethod:@"GET"];

    REQUEST_TYPE = requestType;
//    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:host];
    
    [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

-(void)POSTLogin
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *at = [self percentEscapeURLParameter:csrfToken];
    //    NSString *at1 = [csrfToken stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //    NSString *post = [NSString stringWithFormat:@"user[email]=frodo@shire.com&user[password]=Test123!&authenticity_token=%@", at];
//    NSString *post = [NSString stringWithFormat:@"user[login]=bill.murray@example.com&user[password]=Test123!&authenticity_token=%@", at];
//    NSString *post = [NSString stringWithFormat:@"user[login]=%@&user[password]=$RFde3#1!87&authenticity_token=%@", txtEmail.text, at];
//    NSString *post = [NSString stringWithFormat:@"user[login]=LoadTest18&user[password]=Test123!&authenticity_token=%@", at];
    if (bUseTouchID && [txtPassword.text length] == 0)
    {
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"DCHLApp"  accessGroup:nil];
        szPassword = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    }
    else
        szPassword = txtPassword.text;

    NSString *post = [NSString stringWithFormat:@"user[login]=%@&user[password]=%@&authenticity_token=%@", txtEmail.text, szPassword, at];
    
    NSLog(@"%@", @"\r\r\rLOGIN\r\r\r\r");
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; //NSASCIIStringEncoding
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *pUrl = [NSString stringWithFormat:@"%@/users/sign_in", enrollHost];
    
    [request setURL:[NSURL URLWithString:pUrl]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
//    NSString *pCookie = [NSString stringWithFormat:@"_session_id=%@", customCookie];
    
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                enrollHost, NSHTTPCookieDomain,
                                @"/", NSHTTPCookiePath,  // IMPORTANT!
                                @"_session_id", NSHTTPCookieName,
                                customCookie, NSHTTPCookieValue,
                                nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    
    NSArray* cookies = [NSArray arrayWithObjects: cookie, nil];
    
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSLog(@"%@", [request allHTTPHeaderFields]);
    
    customCookie_a = customCookie;
    
    REQUEST_TYPE = POST_LOGIN_DONE;
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    
    reLoad = TRUE;
}

- (void)makeWebRequest:(NSString*)host type:(int)requestType url:(NSString*)pUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSLog(@"%@", @"\r\r\r MAKE WEB REQUEST \r\r\r\r");
    
    [request setURL:[NSURL URLWithString:pUrl]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                host, NSHTTPCookieDomain,
                                @"/", NSHTTPCookiePath,  // IMPORTANT!
                                @"_session_id", NSHTTPCookieName,
                                customCookie_a, NSHTTPCookieValue,
                                nil];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    NSArray* cookies = [NSArray arrayWithObjects: cookie, nil];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
    NSLog(@"%@", [request allHTTPHeaderFields]);
    
    REQUEST_TYPE = requestType;
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

- (BOOL)shouldTrustProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    // Load up the bundled certificate.
//    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"der"];
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"der"];
    NSData *certData = [[NSData alloc] initWithContentsOfFile:certPath];
    CFDataRef certDataRef = (__bridge_retained CFDataRef)certData;
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, certDataRef);
    
    // Establish a chain of trust anchored on our bundled certificate.
    CFArrayRef certArrayRef = CFArrayCreate(NULL, (void *)&cert, 1, NULL);
    SecTrustRef serverTrust = protectionSpace.serverTrust;
    SecTrustSetAnchorCertificates(serverTrust, certArrayRef);
    
    // Verify that trust.
    SecTrustResultType trustResult;
    SecTrustEvaluate(serverTrust, &trustResult);
    
    // Clean up.
    CFRelease(certArrayRef);
    CFRelease(cert);
    CFRelease(certDataRef);
    
    // Did our custom trust chain evaluate successfully?
    return trustResult == kSecTrustResultUnspecified;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if([challenge.protectionSpace.host isEqualToString:@"mydomain.com"]){
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
//    if ([self shouldTrustProtectionSpace:challenge.protectionSpace]) {
//        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//    } else {
//(DB)        [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
//    }

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSHTTPURLResponse *)response
{
    if (response != nil)
    {
        
//        NSHTTPURLResponse        *httpResponse = (NSHTTPURLResponse *)response;
//        int code = [httpResponse statusCode];
        
        NSArray* authToken = [NSHTTPCookie
                              cookiesWithResponseHeaderFields:[response allHeaderFields]
                              forURL:[NSURL URLWithString:@""]];
        
        if ([authToken count] > 0)
        {
            NSLog(@"cookies from the http POST %@", authToken);
            for (int i = 0; i < [authToken count]; i++)
            {
                NSHTTPCookie *cookie = [authToken objectAtIndex:i];
                NSLog(@"%@ for %@:%@",[cookie name], [cookie domain], [cookie value]);
                if ([[cookie name] isEqualToString:@"_session_id"])
                    customCookie_a = [cookie value];
            }
            //[self doReload];
            reLoad = TRUE;
        }
    }
    
    NSLog(@"%@", [request allHTTPHeaderFields]);
    
    return request;
}

- ( void )connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse        *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger code = [httpResponse statusCode];
    
    if (code == 502)
        REQUEST_TYPE = 502;
    
    _responseData = [[NSMutableData alloc] init];

    if (REQUEST_TYPE == MOBILE_POST_LOGIN_DONE)
    {
        NSDictionary *headerFields = [httpResponse allHeaderFields];
        sSecurityQuestionLocationUrl = [headerFields valueForKeyPath:@"Location"];
    }
    
    NSDictionary *headerFields = [httpResponse allHeaderFields];
    if ([[headerFields valueForKey:@"Set-Cookie"] length] > 0)
    {
        customCookie = [headerFields valueForKey:@"Set-Cookie"];
        
        //EXTRACT COOKIE SESSION_ID
        //
        NSRange startRange = [customCookie rangeOfString:@"="];
        customCookie = [customCookie substringWithRange:NSMakeRange(startRange.location+1, customCookie.length - (startRange.location+1))];
        
        NSRange startRange1 = [customCookie rangeOfString:@";"];
        customCookie = [customCookie substringWithRange:NSMakeRange(0, startRange1.location)];
        //////////////////////////////
        //////////////////////////////
        
    }
    NSLog(@"\n\n COOKIE RECEIVED \n\n\n");
    NSLog(@"\n\n-- %@ --\n\n", customCookie);
    
    NSLog(@"--> %@", [httpResponse allHeaderFields]);
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"\n\n\n\n\n%@\n\n\n\n\n\n", responseString);
    [_responseData appendData:data];
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
    //[spinningWheel stopAnimating];
    [loading setHidden:TRUE];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // This method is used to process the data after connection has made successfully.

        NSLog(@"%s", __FUNCTION__);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
        
        responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
        
        if (reLoad) //Used for Enroll Server Login Only
        {
            [self doReload];
            return;
        }
        
        NSLog(@"response: \r\r%@\r\r", responseString);
        
        //EXTRACT CSRF TOKEN
        //
        NSRange startRange = [responseString rangeOfString:@"<meta name=\"csrf-token\" content=\""];
        if (startRange.length > 0)
        {
            NSString *substring = [responseString substringFromIndex:startRange.location+33];
            NSRange endRange = [substring rangeOfString:@"==\""];
            
            csrfToken = [substring substringWithRange:NSMakeRange(0, endRange.location+2)];
            
            NSLog(@"%@\n", csrfToken);
        }
    
//    http://ec2-54-234-22-53.compute-1.amazonaws.com:3002/api/v1/mobile_api/employers_list
    
    switch (REQUEST_TYPE) {
        case GET_BROKER_ID:
            {
                NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                Settings *obj=[Settings getInstance];
                _brokerId = [dictionary valueForKey:@"id"];
                obj.sUser = [dictionary valueForKey:@"first"];
                
                methodStart = [NSDate date];
                
                loadLabel.text = @"Loading employer data";
                if (iServerType == 1001)
                {
        //            http://ec2-54-234-22-53.compute-1.amazonaws.com:3002/api/v1/mobile_api/employers_list
        //            [self makeWebRequest:enrollHost type:GET_BROKER_EMPLOYERS url:[NSString stringWithFormat:@"%@/broker_agencies/profiles/employers_api?id=%@", enrollHost, _brokerId]];
                    [self makeWebRequest:enrollHost type:GET_BROKER_EMPLOYERS url:[NSString stringWithFormat:@"%@/api/v1/mobile_api/employers_list", enrollHost]];
               }
                else
                {
                    [self makeWebRequest:enrollHost type:GET_BROKER_EMPLOYERS url:[NSString stringWithFormat:@"%@/api/v1/mobile_api/employers_list", enrollHost]];
 //                   [self makeWebRequest:enrollHost type:GET_BROKER_EMPLOYERS url:[NSString stringWithFormat:@"%@/broker_agencies/profiles/employers_api?id=%@", enrollHost, _brokerId]];
                }
            }
            break;
        case GET_BROKER_EMPLOYERS:
        {
            //[spinningWheel stopAnimating];
            [loading setHidden:TRUE];
            Settings *obj=[Settings getInstance];
            obj.sEnrollServer = enrollHost;
            obj.sMobileServer = mobileHost;
            
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
            NSLog(@"executionTime = %f\n\n\n", executionTime);

            if (switchTouchId.on)
            {
                bUseTouchID = YES;
            }
            
            [self performSegueWithIdentifier:@"BrokerTable" sender:nil];
        }
            break;
        case INITIAL_LOGIN_NS:
            {
                NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                enrollHost = [dictionary valueForKey:@"enroll_server"];
                securityQuestion = [dictionary valueForKey:@"security_question"];
                customCookie = [dictionary valueForKey:@"session_key"];
                //NSString *substring = [responseString substringFromIndex:startRange.location+33];
                //    NSLog(@"substring: '%@'", substring);
                NSRange endRange = [customCookie rangeOfString:@"_session_id="];
                
                customCookie_a = [customCookie substringFromIndex:endRange.location+12];
            
                [self askSecurityQuestionFromMobileServer:TRUE];
            //    [self makeWebRequest:enrollHost type:GET_BROKER_ID url:[NSString stringWithFormat:@"http://%@/broker_agencies", enrollHost]];
            }
            break;
        case IS_SECURITY_VALID:
            {
                NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

                enrollHost = [dictionary valueForKey:@"enroll_server"];
//                customCookie = [dictionary valueForKey:@"session_key"];
                customCookie = [dictionary valueForKey:@"session_id"];
                
//                NSRange endRange = [customCookie rangeOfString:@"_session_id="];
                
                customCookie_a = customCookie; //[customCookie substringFromIndex:endRange.location+12];
                
                if (bUseTouchID)
                {
                    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"DCHLApp"  accessGroup:nil];
                    [keychainItem setObject:szPassword forKey:(__bridge id)kSecAttrAccount];
                }
                
                szPassword = @"";
                
                /////////***************************//////////
//                NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
//                NSError *error = nil;
//                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                Settings *obj=[Settings getInstance];
                _brokerId = [dictionary valueForKey:@"id"];
                obj.sUser = [dictionary valueForKey:@"first"];
                
                methodStart = [NSDate date];
                
                loadLabel.text = @"Loading employer data";
                if (iServerType == 1001)
                {
                    //            http://ec2-54-234-22-53.compute-1.amazonaws.com:3002/api/v1/mobile_api/employers_list
                    //            [self makeWebRequest:enrollHost type:GET_BROKER_EMPLOYERS url:[NSString stringWithFormat:@"%@/broker_agencies/profiles/employers_api?id=%@", enrollHost, _brokerId]];
                    [self makeWebRequest:enrollHost type:GET_BROKER_EMPLOYERS url:[NSString stringWithFormat:@"%@/api/v1/mobile_api/employers_list", enrollHost]];
                }
                else
                {
                    [self makeWebRequest:enrollHost type:GET_BROKER_EMPLOYERS url:[NSString stringWithFormat:@"%@/api/v1/mobile_api/employers_list", enrollHost]];
                    //                   [self makeWebRequest:enrollHost type:GET_BROKER_EMPLOYERS url:[NSString stringWithFormat:@"%@/broker_agencies/profiles/employers_api?id=%@", enrollHost, _brokerId]];
                }

                
                
                
                
                
                
                
                
                
 //               loadLabel.text = @"Getting broker id";
   //             [self makeWebRequest:enrollHost type:GET_BROKER_ID url:[NSString stringWithFormat:@"%@/broker_agencies", enrollHost]]; //remove http:// new server sends http with it
            }
            break;
        case INITIAL_GET:       //Only used for Enroll Server Login
            [self POSTLogin];
            break;
        case POST_LOGIN_DONE:   //Only used for Enroll Server Login
            [self makeWebRequest:enrollHost type:GET_BROKER_ID url:[NSString stringWithFormat:@"%@/broker_agencies", enrollHost]];

            break;
        case 502:   //Only used for Enroll Server Login
            {
                [spinningWheel stopAnimating];
                [self showAccountLocked];
            }
            break;

        case MOBILE_POST_LOGIN_DONE:   //Only used for Enroll Server Login
        {
            //            [self makeWebRequest:enrollHost type:GET_BROKER_ID url:[NSString stringWithFormat:@"http://%@/broker_agencies", enrollHost]];
            NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            loadLabel.text = @"Retrieving security question";
            
            securityQuestion = [dictionary valueForKey:@"security_question"];
            
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
            NSLog(@"executionTime = %f\n\n\n", executionTime);

            [self askSecurityQuestionFromMobileServer:TRUE];
        }
            break;

        default:
            break;
    }

    //////////////////////////////
    //////////////////////////////
        
    return;
}

- (void)doReload
{
    reLoad = FALSE;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSLog(@"%@", @"\r\r\rDOING RELOAD\r\r\r\r");
    
    NSString *pUrl = [NSString stringWithFormat:@"%@/", enrollHost];
    
    [request setURL:[NSURL URLWithString:pUrl]];
    //    [request setURL:[NSURL URLWithString:@"http://10.36.27.206:3000/"]];
    
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    //   [request setValue:customCookie forHTTPHeaderField:@"Cookie:"];
    
    
//    NSString *pCookie = [NSString stringWithFormat:@"_session_id=%@", customCookie];
    //    [request setValue:pCookie forHTTPHeaderField:@"Cookie:"];
    
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                enrollHost, NSHTTPCookieDomain,
                                @"/", NSHTTPCookiePath,  // IMPORTANT!
                                @"_session_id", NSHTTPCookieName,
                                customCookie_a, NSHTTPCookieValue,
                                nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    
    NSArray* cookies = [NSArray arrayWithObjects: cookie, nil];
    
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    NSLog(@"%@", [request allHTTPHeaderFields]);
    
    //    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BrokerTable"])
    {
        // Get destination view
        BrokerAccountTableViewController *vc = [segue destinationViewController];
        vc.jsonData = responseString;
        vc.customCookie_a = customCookie_a;
        vc.enrollHost = enrollHost;
        vc._brokerId = _brokerId;
    }
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(void)showAccountLocked
{
    UIAlertController *alertController = nil;

    [loading setHidden:TRUE];
    
    alertController = [UIAlertController  alertControllerWithTitle:@"Login Error"
                                                           message:@"Account has been locked"
                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");

                               }];
    
    [alertController addAction:okAction];
    
    [alertController.view setNeedsLayout];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)askSecurityQuestionFromMobileServer:(BOOL)bIncorrect
{
    UIAlertController *alertController = nil;
    
    alertController = [UIAlertController  alertControllerWithTitle:@"Security Question"
                                                           message:securityQuestion
                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Enter you answer here", @"Login");
     }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                    //   [spinningWheel stopAnimating];
                                           [loading setHidden:TRUE];
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   UITextField *login = alertController.textFields.firstObject;
                            //       if ([login.text caseInsensitiveCompare:@"Blue"] == NSOrderedSame)
                                       [self postSecurityAnswer:login.text];
                                       //[self performSegueWithIdentifier:@"BrokerTable" sender:nil];
                           //        else
                           //            [self askSecurityQuestion:TRUE];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [alertController.view setNeedsLayout];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)postSecurityAnswer:(NSString *)answer
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    loadLabel.text = @"Submitting credentials";
//    NSString *at = [self percentEscapeURLParameter:csrfToken];
    //    NSString *at1 = [csrfToken stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //    NSString *post = [NSString stringWithFormat:@"user[email]=frodo@shire.com&user[password]=Test123!&authenticity_token=%@", at];
    //    NSString *post = [NSString stringWithFormat:@"user[email]=bill.murray@example.com&user[password]=Test123!&authenticity_token=%@", at];
//    NSString *post = [NSString stringWithFormat:@"user[email]=%@&user[password]=Test123!&authenticity_token=%@", txtEmail.text, at];
    NSString *post = [NSString stringWithFormat:@"security_answer=%@", answer];
    
    NSLog(@"%@", @"\r\r\rLOGIN\r\r\r\r");
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; //NSASCIIStringEncoding
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *pUrl = sSecurityQuestionLocationUrl; //@"http://ec2-54-234-22-53.compute-1.amazonaws.com:3001/login/1"; //[NSString stringWithFormat:@"http://%@/users/sign_in", enrollHost];
    
    NSURL *candidateURL = [NSURL URLWithString:pUrl];
    // WARNING > "test" is an URL according to RFCs, being just a path
    // so you still should check scheme and all other NSURL attributes you need
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        // candidate is a well-formed url with:
        //  - a scheme (like http://)
        //  - a host (like stackoverflow.com)
    }
    else
        pUrl = [NSString stringWithFormat:@"%@%@", sSecurityQuestionLocationHost, sSecurityQuestionLocationUrl];
    
    [request setURL:[NSURL URLWithString:pUrl]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    //    NSString *pCookie = [NSString stringWithFormat:@"_session_id=%@", customCookie];
    
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                request.URL.host, NSHTTPCookieDomain, //@"http://ec2-54-234-22-53.compute-1.amazonaws.com:3001/login/1"
                                @"/", NSHTTPCookiePath,  // IMPORTANT!
                                @"_session_id", NSHTTPCookieName,
                                customCookie, NSHTTPCookieValue,
                                nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    
    NSArray* cookies = [NSArray arrayWithObjects: cookie, nil];
    
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSLog(@"%@", [request allHTTPHeaderFields]);
    
    customCookie_a = customCookie;
    
    REQUEST_TYPE = IS_SECURITY_VALID;
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    
//    reLoad = TRUE;
}

-(void)customActivityView
{
    loading = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
//    loading = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-110, 200, 220, 140)];
    UIView *centerloading = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-110, self.view.frame.size.height/2-70, 220, 140)];
    centerloading.layer.cornerRadius = 15;
    centerloading.opaque = NO;
    centerloading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    
    loading.layer.cornerRadius = 0;
    loading.opaque = NO;
    loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    
    loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 22)];
    
    loadLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    loadLabel.textAlignment = NSTextAlignmentCenter;
    loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    loadLabel.backgroundColor = [UIColor clearColor];
    
    [centerloading addSubview:loadLabel];
    
    UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinning.frame = CGRectMake(220/2-18, 140/2-18, 37, 37);
    [spinning startAnimating];
    
    [centerloading addSubview:spinning];
    [loading addSubview:centerloading];
    [loading setHidden:TRUE];
    
    [self.view addSubview:loading];
}

@end

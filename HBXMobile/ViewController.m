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
#import "BrokerAccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Settings.h"

#define FS_ERROR_KEY(code)                    [NSString stringWithFormat:@"%d", code]
#define FS_ERROR_LOCALIZED_DESCRIPTION(code)  NSLocalizedStringFromTable(FS_ERROR_KEY(code), @"FSError", nil)
#define METERS_PER_MILE 1609.344
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//#define HOST @"10.36.27.206:3000"

#define HOST @"10.36.27.236:3000"
#define HOST_NS @"10.36.27.236:3001"

//#define HOST @"localhost:3000"


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
//    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showbrokeremployers) name:kReloadJSON object:nil];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    UIImageView *pView1 = [[UIImageView alloc] initWithFrame:CGRectMake(screenSize.width/2-50, 0, 100, 45)];
    pView1.backgroundColor = [UIColor clearColor];
    pView1.image = [UIImage imageNamed:@"dchllogo_withouttag-2.png"];
    pView1.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationController.navigationBar addSubview:pView1];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;


    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    spinningWheel = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinningWheel.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    spinningWheel.center = self.view.center;
    spinningWheel.layer.cornerRadius = 05;
    spinningWheel.opaque = NO;
    spinningWheel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
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


    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600)
    {
        // Place iPhone/iPod specific code here...
        topView.frame = CGRectMake(25, 135, screenSize.width - 45, 330);
        
        self.submitButton.frame = CGRectMake(20, 265, screenSize.width - 80, 44);
        txtEmail.frame = CGRectMake(20, txtEmail.frame.origin.y, topView.frame.size.width - 40, 40); //txtEmail.frame.size.height);
        txtPassword.frame = CGRectMake(20, txtEmail.frame.origin.y + txtEmail.frame.size.height + 20, topView.frame.size.width - 40, 40); //txtPassword.frame.size.height);
//        self.enableTouchIdButton.frame = CGRectMake(screenSize.width - 160, self.enableTouchIdButton.frame.origin.y, 24, self.enableTouchIdButton.frame.size.height);
//        lblEnableTouchID.frame = CGRectMake(self.enableTouchIdButton.frame.origin.x + 29, lblEnableTouchID.frame.origin.y, screenSize.width - 40, lblEnableTouchID.frame.size.height);
        
        lblEnableTouchID.frame = CGRectMake(20, txtPassword.frame.origin.y + txtPassword.frame.size.height + 20, 150, 40); //lblEnableTouchID.frame.size.height);
        switchTouchId.frame = CGRectMake(topView.frame.origin.x + topView.frame.size.width - switchTouchId.frame.size.width - 40, lblEnableTouchID.frame.origin.y + 5, switchTouchId.frame.size.width, 40);
        
        lblSaveUserID.frame = CGRectMake(20, lblEnableTouchID.frame.origin.y + lblEnableTouchID.frame.size.height + 20, 150, 40); //lblSaveUserID.frame.size.height);
        switchSaveMe.frame = CGRectMake(topView.frame.origin.x + topView.frame.size.width - switchSaveMe.frame.size.width - 40, lblSaveUserID.frame.origin.y + 5, switchSaveMe.frame.size.width, 40);

        bottomView.frame = CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y + 60, screenSize.width, screenSize.height - (bottomView.frame.origin.y + 60));
        
        lblDisclaimer.frame = CGRectMake(screenSize.width / 2 - 90, 80, 180, 204);//lblDisclaimer.frame.size.height);
        
 /*
        UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(22, txtEmail.frame.origin.y + txtEmail.frame.size.height + 10, screenSize.width - 80, 1)];
        separator.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [topView addSubview:separator];
        
        UIView * separator1 = [[UIView alloc] initWithFrame:CGRectMake(22, txtPassword.frame.origin.y + txtPassword.frame.size.height + 10, screenSize.width - 80, 1)];
        separator1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [topView addSubview:separator1];
        
        UIView * separator2 = [[UIView alloc] initWithFrame:CGRectMake(22, lblEnableTouchID.frame.origin.y + lblEnableTouchID.frame.size.height + 10, screenSize.width - 80, 1)];
        separator2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [topView addSubview:separator2];
*/
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        topView.center = CGPointMake(CGRectGetMidX(self.view.bounds), topView.center.y);
        bottomView.center = CGPointMake(CGRectGetMidX(self.view.bounds), bottomView.center.y);
        

    }
    else
    {
        // Place iPad-specific code here...
  //      self.submitButton.frame = CGRectMake(screenSize.width /2 - 100, self.submitButton.frame.origin.y, 200, 45);
    }
/*
    NSString *dateStr = [NSString stringWithUTF8String:__DATE__];
    NSString *timeStr = [NSString stringWithUTF8String:__TIME__];
*/
/*
    UIImageView *pGear = [[UIImageView alloc] initWithFrame:CGRectMake(10, screenSize.height - 36, 32, 32)];
    pGear.backgroundColor = [UIColor clearColor];
    pGear.image = [UIImage imageNamed:@"gear.png"];
    pGear.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:pGear];
*/
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, screenSize.height - 36, 32, 32)];
    UIImage *img = [UIImage imageNamed:@"gear.png"];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showConfig:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    lblDB = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width /2 - 100, screenSize.height - 14, 200, 10)];
    lblDB.textAlignment = NSTextAlignmentCenter;
    lblDB.font = [UIFont systemFontOfSize:10];
    lblDB.textColor = [UIColor whiteColor];
    [self.view addSubview:lblDB];
    
    lblVersion.numberOfLines = 3;
    lblVersion.lineBreakMode = NSLineBreakByWordWrapping;
    lblVersion.frame = CGRectMake(bottomView.frame.size.width - 50, bottomView.frame.size.height - 30, 70, 15);
    lblVersion.text = [NSString stringWithFormat:@"v %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(22, txtEmail.frame.origin.y + txtEmail.frame.size.height + 10, topView.frame.size.width - 22, 1)];
    separator.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [topView addSubview:separator];
    
    UIView * separator1 = [[UIView alloc] initWithFrame:CGRectMake(22, txtPassword.frame.origin.y + txtPassword.frame.size.height + 10, topView.frame.size.width - 22, 1)];
    separator1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [topView addSubview:separator1];
    
    UIView * separator2 = [[UIView alloc] initWithFrame:CGRectMake(22, lblEnableTouchID.frame.origin.y + lblEnableTouchID.frame.size.height + 10, topView.frame.size.width - 22, 1)];
    separator2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [topView addSubview:separator2];

    self.submitButton.layer.cornerRadius = 10; // this value vary as per your desire
    self.submitButton.clipsToBounds = YES;
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"DCHLApp"  accessGroup:nil];
    
//    NSString *password = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrLabel];
    //  [keychainItem setObject:@"password" forKey:(__bridge id)kSecAttrAccount];
    //  [keychainItem setObject:@"dboyd5@@hotmail.com" forKey:(__bridge id)kSecAttrLabel];
    //  Get the stored data before the view loads
    //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //  NSString *sSaveUser = [defaults objectForKey:@"saveUser"];
    //  NSString *sEnableTouchID = [defaults objectForKey:@"enableTouchID"];
    UIImageView *pView = [[UIImageView alloc] initWithFrame:CGRectMake(screenSize.width/2-100, 50, 200, 45)];
    pView.backgroundColor = [UIColor clearColor];
    pView.image = [UIImage imageNamed:@"dchllogo_withouttag-2.png"];
    pView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:pView];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"saveUserInfo"])
    {
        txtEmail.text = username;
//      txtPassword.text = password;
        
        switchSaveMe.on = TRUE;
        bSaveUserInfo = TRUE;
        
        bUseTouchID = [[NSUserDefaults standardUserDefaults] boolForKey:@"useTouchID"];
        if (bUseTouchID)
        {
            switchTouchId.on = TRUE;
        }
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)showConfig:(id)sender
{
    [self performSegueWithIdentifier:@"Config View" sender:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [spinningWheel startAnimating];

    txtEmail.text = @"bill.murray@example.com";
    
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
//                [self performSegueWithIdentifier:@"Show My Account" sender:nil];
#if !(TARGET_IPHONE_SIMULATOR)
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if( [txtEmail.text caseInsensitiveCompare:@"john@dc.gov"] == NSOrderedSame )        //For DEMO Only
//    {
        // strings are equal except for possibly case
//        if( [txtPassword.text isEqualToString:@"password"] ) {
            if (switchSaveMe.isOn)
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
            
            [[NSUserDefaults standardUserDefaults] setBool:switchSaveMe.isOn forKey:@"saveUserInfo"];
            [[NSUserDefaults standardUserDefaults] setBool:switchTouchId.isOn forKey:@"useTouchID"];
/*
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"useEnrollDB"])
                [self login:sender];
            else
                [self askSecurityQuestion:FALSE];
    */
    ;
    switch([[[NSUserDefaults standardUserDefaults] stringForKey:@"whichServer"] intValue])
    {
        case 1001:
            enrollHost = [[NSUserDefaults standardUserDefaults] stringForKey:@"enrollServer"];
            [self login:enrollHost type:INITIAL_GET url:[NSString stringWithFormat:@"http://%@/users/sign_in", enrollHost]];
            break;
        case 1002:
            mobileHost = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobileServer"];
            [self login:mobileHost type:INITIAL_LOGIN_NS url:[NSString stringWithFormat:@"http://%@/login", mobileHost]];
            break;
        case 1003:
        default:
            [self askSecurityQuestion:FALSE];
            break;
    }
#else
    switch([[[NSUserDefaults standardUserDefaults] stringForKey:@"whichServer"] intValue])
    {
        case 1001:
        {
            enrollHost = [[NSUserDefaults standardUserDefaults] stringForKey:@"enrollServer"];
            [self login:enrollHost type:INITIAL_GET url:[NSString stringWithFormat:@"http://%@/users/sign_in", enrollHost]];
        }
            break;
        case 1002:
            mobileHost = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobileServer"];
            [self login:mobileHost type:INITIAL_LOGIN_NS url:[NSString stringWithFormat:@"http://%@/login", mobileHost]];
            break;
        case 1003:
        default:
            [self performSegueWithIdentifier:@"Broker View" sender:nil];
            break;
    }
#endif
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
                                       [spinningWheel stopAnimating];
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   UITextField *login = alertController.textFields.firstObject;
                                   if ([login.text caseInsensitiveCompare:@"Blue"] == NSOrderedSame)
                                       [self performSegueWithIdentifier:@"Broker View" sender:nil];
                                   else
                                       [self askSecurityQuestion:TRUE];
                               }];
    
    [alertController addAction:cancelAction];
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
                                       [spinningWheel stopAnimating];
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   UITextField *login = alertController.textFields.firstObject;
                                   
                                   if ([login.text caseInsensitiveCompare:@"Blue"] == NSOrderedSame)
                                       [self performSegueWithIdentifier:@"Broker View" sender:nil];
                                   else
                                       [self askSecurityQuestionFromMobileServer:TRUE];
                                    
               //                    [self sendSecurityAnswer];
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

- (void)clearCookiesForURL {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/users/sign_in", enrollHost]]];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"Deleting cookie for domain: %@", [cookie domain]);
        [cookieStorage deleteCookie:cookie];
    }
}

-(void)sendSecurityAnswer
{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
//        NSString *at = [self percentEscapeURLParameter:csrfToken];
        //    NSString *at1 = [csrfToken stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        //    NSString *post = [NSString stringWithFormat:@"user[email]=frodo@shire.com&user[password]=Test123!&authenticity_token=%@", at];
        NSString *post = [NSString stringWithFormat:@"security=%@", @"blue"];
        
        NSLog(@"%@", @"\r\r POST SECURITY \r\r\r\r");
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; //NSASCIIStringEncoding
        
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        
        NSString *pUrl = [NSString stringWithFormat:@"http://%@/login?get_security_answer", enrollHost];
        
        [request setURL:[NSURL URLWithString:pUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];

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

}

- (IBAction)login:(NSString *)host type:(int)requestType url:(NSString*)pUrl
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self clearCookiesForURL];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setURL:[NSURL URLWithString:pUrl]];
    
    [request setHTTPMethod:@"GET"];

    REQUEST_TYPE = requestType;
    
    [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
 
/*
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pUrl]];

    [request setHTTPMethod:@"GET"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSString *rString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@", rString);
             
             _responseData = [[NSMutableData alloc] init];
             
            NSHTTPURLResponse        *httpResponse = (NSHTTPURLResponse *)response;
             
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

             //EXTRACT CSRF TOKEN
             //
             NSRange startRange = [rString rangeOfString:@"<meta name=\"csrf-token\" content=\""];
             if (startRange.length > 0)
             {
                 NSString *substring = [rString substringFromIndex:startRange.location+33];
                 NSRange endRange = [substring rangeOfString:@"==\""];
                 
                 csrfToken = [substring substringWithRange:NSMakeRange(0, endRange.location+2)];
                 
                 NSLog(@"%@\n", csrfToken);
                 
                 if ([csrfToken length] > 0 && [customCookie length] > 0)
                     [self POSTLogin1];
             }

         }
     }];
*/
}

-(void)POSTLogin1
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *at = [self percentEscapeURLParameter:csrfToken];
    //    NSString *at1 = [csrfToken stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //    NSString *post = [NSString stringWithFormat:@"user[email]=frodo@shire.com&user[password]=Test123!&authenticity_token=%@", at];
    //    NSString *post = [NSString stringWithFormat:@"user[email]=bill.murray@example.com&user[password]=Test123!&authenticity_token=%@", at];
    NSString *post = [NSString stringWithFormat:@"user[email]=%@&user[password]=Test123!&authenticity_token=%@", txtEmail.text, at];
    
    NSLog(@"%@", @"\r\r\rLOGIN\r\r\r\r");
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; //NSASCIIStringEncoding
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *pUrl = [NSString stringWithFormat:@"http://%@/users/sign_in", enrollHost];
    
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
/*
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
 */
    reLoad = TRUE;
 
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
//         [self makeWebRequest:enrollHost type:GET_BROKER_ID url:[NSString stringWithFormat:@"http://%@/broker_agencies", enrollHost]];
        NSHTTPURLResponse        *httpResponse = (NSHTTPURLResponse *)response;
         NSArray* authToken = [NSHTTPCookie
                               cookiesWithResponseHeaderFields:[httpResponse allHeaderFields]
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
     
     NSLog(@"%@", [request allHTTPHeaderFields]);

                     [self doReload];
     }];
}

-(void)POSTLogin
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *at = [self percentEscapeURLParameter:csrfToken];
    //    NSString *at1 = [csrfToken stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //    NSString *post = [NSString stringWithFormat:@"user[email]=frodo@shire.com&user[password]=Test123!&authenticity_token=%@", at];
//    NSString *post = [NSString stringWithFormat:@"user[email]=bill.murray@example.com&user[password]=Test123!&authenticity_token=%@", at];
    NSString *post = [NSString stringWithFormat:@"user[email]=%@&user[password]=Test123!&authenticity_token=%@", txtEmail.text, at];
    
    NSLog(@"%@", @"\r\r\rLOGIN\r\r\r\r");
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; //NSASCIIStringEncoding
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *pUrl = [NSString stringWithFormat:@"http://%@/users/sign_in", enrollHost];
    
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

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([self shouldTrustProtectionSpace:challenge.protectionSpace]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    } else {
        [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
    }
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
//    int code = [httpResponse statusCode];
    
    _responseData = [[NSMutableData alloc] init];
    
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
    NSLog(@"%@", responseString);
    [_responseData appendData:data];
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
    [spinningWheel stopAnimating];
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
    
    
    switch (REQUEST_TYPE) {
        case GET_BROKER_ID:
            {
                NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                Settings *obj=[Settings getInstance];
                _brokerId = [dictionary valueForKey:@"id"];
                obj.sUser = [dictionary valueForKey:@"first"];
                
                [self makeWebRequest:enrollHost type:GET_BROKER_EMPLOYERS url:[NSString stringWithFormat:@"http://%@/broker_agencies/profiles/employers_api?id=%@", enrollHost, _brokerId]];
            }
            break;
        case GET_BROKER_EMPLOYERS:
        {
            [spinningWheel stopAnimating];
            
            Settings *obj=[Settings getInstance];
            obj.sEnrollServer = enrollHost;
            obj.sMobileServer = mobileHost;
            
            [self performSegueWithIdentifier:@"Broker View" sender:nil];
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
            
            //    [self askSecurityQuestionFromMobileServer:TRUE];
                [self makeWebRequest:enrollHost type:GET_BROKER_ID url:[NSString stringWithFormat:@"http://%@/broker_agencies", enrollHost]];
            }
            break;
        case IS_SECURITY_VALID:
            
            break;
        case INITIAL_GET:       //Only used for Enroll Server Login
            [self POSTLogin];
            break;
        case POST_LOGIN_DONE:   //Only used for Enroll Server Login
            [self makeWebRequest:enrollHost type:GET_BROKER_ID url:[NSString stringWithFormat:@"http://%@/broker_agencies", enrollHost]];

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
    
    NSString *pUrl = [NSString stringWithFormat:@"http://%@/", enrollHost];
    
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
    //  customCookie = customCookie_a;
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
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"whichServer"] intValue] == 1001)
        lblDB.text = @"using enroll database server";
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"whichServer"] intValue] == 1002)
        lblDB.text = @"using mobile notification server";
    else 
        lblDB.text = @"using github for broker data";


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
                                            [self performSegueWithIdentifier:@"Broker View" sender:nil];
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
                /*
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:authError.description
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                // Commented this out if touchid is not enabled.
                // Maybe add some code to ask or something
                //                [alertView show];
                 */
            });
        }
    }
#endif
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Broker View"])
    {
        /*
        // Get destination view
        BrokerAccountViewController *vc = [segue destinationViewController];
        vc.jsonData = responseString;
        vc.customCookie_a = customCookie_a;
        vc.enrollHost = enrollHost;
        vc._brokerId = _brokerId;
         */
    }
}

-(void)dismissKeyboard {
        [self.view endEditing:YES];
}

@end

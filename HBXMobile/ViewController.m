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
#import <QuartzCore/QuartzCore.h>

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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
//        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    UIImageView *pView1 = [[UIImageView alloc] initWithFrame:CGRectMake(screenSize.width/2-50, 0, 100, 45)];
    pView1.backgroundColor = [UIColor clearColor];
    pView1.image = [UIImage imageNamed:@"dchllogo_withouttag-2.png"];
    pView1.contentMode = UIViewContentModeScaleAspectFit;
//    self.navigationItem.titleView = pView1;
    
    [self.navigationController.navigationBar addSubview:pView1];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;


    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    spinningWheel = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinningWheel.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    spinningWheel.center = self.view.center;
    [self.view addSubview:spinningWheel];
    [spinningWheel bringSubviewToFront:self.view];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enableTouchIdSwitch:(id)sender {
    if (switchTouchId.on)
        NSLog(@"On");
    else
        NSLog(@"Off");
    
    [[NSUserDefaults standardUserDefaults] setBool:switchTouchId.isOn forKey:@"useTouchID"];
}

- (IBAction)handleButtonClick:(id)sender
{
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

//            [self loginToServer];
 //           [self performSegueWithIdentifier:@"Show My Account" sender:nil];
 //         [self performSegueWithIdentifier:@"Broker View" sender:nil];
        [self askSecurityQuestion:FALSE];
//            [self performSegueWithIdentifier:@"Select Plan Employee" sender:nil];
//        }
        
//    }
#else
//    [self performSegueWithIdentifier:@"Select Plan Employee" sender:nil];
//  [self performSegueWithIdentifier:@"Show My Account" sender:nil];
//    [self loginToServer];

    [self askSecurityQuestion:FALSE];
//       [self performSegueWithIdentifier:@"Broker View" sender:nil];
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

-(void)loginToServer
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [spinningWheel startAnimating];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //  NSString *post = [NSString stringWithFormat:@"article=1234&title=%@&text=%@&author=%@",@"username",@"password",@"bob"];
    //        NSString *post = [NSString stringWithFormat:@"article=1234&email=%@&password=%@&author=%@",@"dboyd5@hotmail.com",@"password",@"bob"];
    NSString *post = [NSString stringWithFormat:@"email=%@",@"frodo@shire.com"];
    
    NSDictionary * postDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"", @"http://10.36.27.206:3000/", @"frodo@shire.com", @"Test123!", @"Test123!", @"invitation_id", @"Create account", nil]
                                                                forKeys:[NSArray arrayWithObjects:@"authenticity_token", @"referer", @"email", @"password", @"password_confirmation", @"referer", @"commit", nil]];

    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDictionary options:0 error:&error];
    
    //    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
        [request setURL:[NSURL URLWithString:@"http://10.36.27.206:3000/employers/employer_profiles/57167b16ea497f05d200000b/edit?add_staff=no&tab=profile"]];
    [request setURL:[NSURL URLWithString:@"http://10.36.27.206:3000/"]];
    
    [request setHTTPMethod:@"GET"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
 //   [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
 //   [request setValue:@"text/html" forHTTPHeaderField:@"accept"];
//    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
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

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
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
    NSLog(@"%s", __FUNCTION__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
    [spinningWheel stopAnimating];
    [self performSegueWithIdentifier:@"Show My Account" sender:nil];

    return;
/*
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"RoR Server Response"
                                  message:responseString
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
*/    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
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

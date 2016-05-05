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
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    UIImage *img = [UIImage imageNamed:@"dchllogo_withouttag-2.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
//    self.navigationItem.titleView = imgView;
    
    UIImageView *pView1 = [[UIImageView alloc] initWithFrame:CGRectMake(screenSize.width/2-50, 0, 100, 45)];
    pView1.backgroundColor = [UIColor clearColor];
    pView1.image = [UIImage imageNamed:@"dchllogo_withouttag-2.png"];
    pView1.contentMode = UIViewContentModeScaleAspectFit;
//    self.navigationItem.titleView = pView1;
    
    [self.navigationController.navigationBar addSubview:pView1];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = YES;

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
 //           [self.enableTouchIdButton setHidden:TRUE];
 //           [lblEnableTouchID setHidden:TRUE];
        }
    }
    

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
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
        
 //       lblDisclaimer.frame = CGRectMake(20, lblDisclaimer.frame.origin.y, screenSize.width - 40, lblDisclaimer.frame.size.height);
        lblSaveUserID.frame = CGRectMake(20, lblEnableTouchID.frame.origin.y + lblEnableTouchID.frame.size.height + 20, 150, 40); //lblSaveUserID.frame.size.height);
        switchSaveMe.frame = CGRectMake(topView.frame.origin.x + topView.frame.size.width - switchSaveMe.frame.size.width - 40, lblSaveUserID.frame.origin.y + 5, switchSaveMe.frame.size.width, 40);

        
        bottomView.frame = CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y, screenSize.width, screenSize.height - bottomView.frame.origin.x);

        
        UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(22, txtEmail.frame.origin.y + txtEmail.frame.size.height + 10, screenSize.width - 80, 1)];
        separator.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [topView addSubview:separator];

        UIView * separator1 = [[UIView alloc] initWithFrame:CGRectMake(22, txtPassword.frame.origin.y + txtPassword.frame.size.height + 10, screenSize.width - 80, 1)];
        separator1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [topView addSubview:separator1];

        UIView * separator2 = [[UIView alloc] initWithFrame:CGRectMake(22, lblEnableTouchID.frame.origin.y + lblEnableTouchID.frame.size.height + 10, screenSize.width - 80, 1)];
        separator2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [topView addSubview:separator2];
        
//        UIView * separator3 = [[UIView alloc] initWithFrame:CGRectMake(22, lblSaveUserID.frame.origin.y + lblSaveUserID.frame.size.height + 10, screenSize.width - 80, 1)];
//        separator3.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
 //       [topiew addSubview:separator3];
//        UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(x, y, 320, 1)];
//        separator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
//        [self.view addSubview:separator];
     //   [lblSaveUserID sizeToFit];
    } else {
        // Place iPad-specific code here...
        self.submitButton.frame = CGRectMake(screenSize.width /2 - 100, self.submitButton.frame.origin.y, 200, 45);
    }
    
    self.submitButton.layer.cornerRadius = 10; // this value vary as per your desire
    self.submitButton.clipsToBounds = YES;

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
    UIImageView *pView = [[UIImageView alloc] initWithFrame:CGRectMake(screenSize.width/2-100, 50, 200, 45)];
    pView.backgroundColor = [UIColor clearColor];
    pView.image = [UIImage imageNamed:@"dchllogo_withouttag-2.png"];
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
//    if( [txtEmail.text caseInsensitiveCompare:@"john@dc.gov"] == NSOrderedSame )        //For DEMO Only
//    {
        // strings are equal except for possibly case
//        if( [txtPassword.text isEqualToString:@"password"] ) {
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

//            [self loginToServer];
            [self performSegueWithIdentifier:@"Show My Account" sender:nil];
//            [self performSegueWithIdentifier:@"Select Plan Employee" sender:nil];
//        }
        
//    }
#else
//    [self performSegueWithIdentifier:@"Select Plan Employee" sender:nil];
   [self performSegueWithIdentifier:@"Show My Account" sender:nil];
//    [self loginToServer];
#endif
}


-(void)loginToServer
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [spinningWheel startAnimating];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //  NSString *post = [NSString stringWithFormat:@"article=1234&title=%@&text=%@&author=%@",@"username",@"password",@"bob"];
    //        NSString *post = [NSString stringWithFormat:@"article=1234&email=%@&password=%@&author=%@",@"dboyd5@hotmail.com",@"password",@"bob"];
    NSString *post = [NSString stringWithFormat:@"email=%@",@"dboyd5@hotmail.com"];
    
    NSDictionary * postDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"", @"http://10.36.27.206:3000/", @"frodo@shire.com", @"Test123!", @"Test123!", @"invitation_id", @"Create account", nil]
                                                                forKeys:[NSArray arrayWithObjects:@"authenticity_token", @"referer", @"email", @"password", @"password_confirmation", @"referer", @"commit", nil]];

    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDictionary options:0 error:&error];
    
    //    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];

//    [request setURL:[NSURL URLWithString:@"http://ec2-54-165-241-146.compute-1.amazonaws.com:3000/login"]];
//    [request setURL:[NSURL URLWithString:@"https://localhost/MAMP/?language=English"]];
//    [request setURL:[NSURL URLWithString:@"http://10.36.27.206:3000/employers/employer_profiles/57167b16ea497f05d2000009?tab=home"]];
    
        [request setURL:[NSURL URLWithString:@"http://10.36.27.206:3000/employers/employer_profiles/57167b16ea497f05d200000b/edit?add_staff=no&tab=profile"]];
    [request setURL:[NSURL URLWithString:@"http://10.36.27.206:3000/"]];
    
    //    [request setURL:[NSURL URLWithString:@"http://10.29.43.96:3000/articles"]];
    //        [request setURL:[NSURL URLWithString:@"http://localhost:3000/curl_example"]];
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

//
//  MyPlanWebViewController.h
//  HBXMobile
//
//  Created by David Boyd on 3/16/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlanWebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *url;
@end

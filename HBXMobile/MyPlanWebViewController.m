//
//  MyPlanWebViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/16/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "MyPlanWebViewController.h"

@interface MyPlanWebViewController ()

@end

@implementation MyPlanWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    self.webView.frame = CGRectMake(0,60,screenSize.width,screenSize.height); //self.view.frame.size.width,500);

    
}

-(void)viewWillAppear:(BOOL)animated {

    


}

-(void)viewDidAppear:(BOOL)animated {

    self.webView.scalesPageToFit = YES;
    
    self.webView.autoresizesSubviews = YES;
    self.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    // Do any additional setup after loading the view.
    //    NSURL *targetURL = [NSURL URLWithString:@"https://dc.checkbookhealth.org/hie/dc/2016/assets/pdfs/86052DC0400005-01.pdf"];
    
    //    self.url = @"http://www.yahoo.com";
    NSURL *targetURL = [NSURL URLWithString:self.url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.webView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// This will get called too before the view appears
@end

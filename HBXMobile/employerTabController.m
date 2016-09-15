//
//  employerTabController.m
//  HBXMobile
//
//  Created by John Boyd on 9/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "employerTabController.h"

@interface employerTabController ()

@end

@implementation employerTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //    self.secondViewController = (YourSecondViewController*) viewController;
    //    self.secondViewController.aLabel.text = self.stringFromTableViewController;
}

@end

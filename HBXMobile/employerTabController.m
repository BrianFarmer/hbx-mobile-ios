//
//  employerTabController.m
//  HBXMobile
//
//  Created by John Boyd on 9/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "employerTabController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface employerTabController ()

@end

@implementation employerTabController

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self setDelegate:self];
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBG1.png"]]; //[UIImage imageNamed:@"tabbar_selected.png"]];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       UIColorFromRGB(0x007BC4), NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    [UITabBarItem.appearance setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];

    
    UITabBarItem *item0 = self.tabBar.items[0];    
//    self.tabBarItem.image = [self imageWithImage:image scaledToSize:CGSizeMake(30, 30)];
    [item0 setImage:[[self imageWithImage:[UIImage imageNamed:@"infonormal48.png"] scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    [item0 setImage:[[UIImage imageNamed:@"infonormal32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item0 setSelectedImage:[[UIImage imageNamed:@"infoactive32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item0 setSelectedImage:[[self imageWithImage:[UIImage imageNamed:@"infoactive48.png"] scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *item1 = self.tabBar.items[1];
    [item1 setImage:[[self imageWithImage:[UIImage imageNamed:@"rosternormal48.png"]  scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage:[[self imageWithImage:[UIImage imageNamed:@"rosteractive48.png"] scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    UITabBarItem *item2 = self.tabBar.items[2];
    [item2 setImage:[[self imageWithImage:[UIImage imageNamed:@"costsnormal48.png"]  scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[self imageWithImage:[UIImage imageNamed:@"costsactive48.png"] scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
/*
    [item2 setImage:[[UIImage imageNamed:@"costsnormal32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"costsactive32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
*/
    UITabBarItem *item3 = self.tabBar.items[3];
    [item3 setImage:[[self imageWithImage:[UIImage imageNamed:@"plansnormal48.png"]  scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[self imageWithImage:[UIImage imageNamed:@"plansactive48.png"] scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

 /*
    [item3 setImage:[[UIImage imageNamed:@"plansnormal32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"plansactive32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
*/
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
/*
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    // http://stackoverflow.com/questions/5161730/iphone-how-to-switch-tabs-with-an-animation
    NSUInteger controllerIndex = [self.viewControllers indexOfObject:viewController];
    
    if (controllerIndex == tabBarController.selectedIndex) {
        return NO;
    }
    
    // Get the views.
    UIView *fromView = tabBarController.selectedViewController.view;
    UIView *toView = [tabBarController.viewControllers[controllerIndex] view];
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = controllerIndex > tabBarController.selectedIndex;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    toView.frame = CGRectMake((scrollRight ? screenWidth : -screenWidth), viewSize.origin.y, screenWidth, viewSize.size.height);
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame = CGRectMake((scrollRight ? -screenWidth : screenWidth), viewSize.origin.y, screenWidth, viewSize.size.height);
                         toView.frame = CGRectMake(0, viewSize.origin.y, screenWidth, viewSize.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             tabBarController.selectedIndex = controllerIndex;
                         }
                     }];
    
    return NO;
*/
/*
    
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    if (fromView == toView)
        return false;
    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.3
                       options: toIndex > fromIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = toIndex;
                        }
                    }];
    return true;
 */
//}
@end

//
//  MyAccountViewController.h
//  HBXMobile
//
//  Created by David Boyd on 3/7/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController : UIViewController
{
    IBOutlet UITableView    *myAccountTable;
    
    NSMutableArray *tableData;
    NSDictionary *dictionary;
  
    NSArray *subscriberPlans;
    NSArray *coverageKeys;
    NSArray *planKeys;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end

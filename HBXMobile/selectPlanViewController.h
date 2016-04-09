//
//  selectPlanViewController.h
//  HBXMobile
//
//  Created by David Boyd on 3/24/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectPlanViewController : UIViewController
{
    IBOutlet UITableView *plansTable;
    
    NSString *responseString;
    
    NSDictionary *dictionary;
    NSArray *subscriberPlans;
        NSArray *coverageKeys;
}

@property(nonatomic, assign) int level;
@property(nonatomic, assign) NSInteger selectedPlan;

@end

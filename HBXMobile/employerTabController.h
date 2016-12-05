//
//  employerTabController.h
//  HBXMobile
//
//  Created by John Boyd on 9/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "brokerEmployersData.h"


@interface employerTabController : UITabBarController <UITabBarControllerDelegate>
{

}

@property (strong, nonatomic) brokerEmployersData *employerData;
@property (strong, nonatomic) NSDictionary *detailDictionary;
@property (strong, nonatomic) NSDictionary *rosterDictionary;
@property(nonatomic, assign) NSString *enrollHost;
@property(nonatomic, assign) NSString *customCookie_a;

@property(nonatomic, assign) NSString *sortOrder;
@property(nonatomic, assign) NSIndexPath *iPath;

@property(strong, nonatomic) NSArray *rosterList;

@property (nonatomic, assign) double employer_contribution;
@property (nonatomic, assign) double employee_costs;

@property (nonatomic, assign) int enrolled;
@property (nonatomic, assign) int waived;
@property (nonatomic, assign) int notenrolled;
@property (nonatomic, assign) int terminated;
@property (nonatomic, assign) int total_employees;

@property (nonatomic, assign) NSInteger current_coverage_year_index;

@end

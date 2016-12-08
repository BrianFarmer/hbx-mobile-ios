//
//  EmployeeProfileViewController.h
//  HBXMobile
//
//  Created by David Boyd on 10/5/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "brokerEmployersData.h"

@protocol EmployeeProfileDelegate
-(void)setCoverageYearIndex:(NSInteger)index;
-(NSArray*)getEmployeeData;
@end

@interface EmployeeProfileViewController : UIViewController <HeaderViewDelegate>
{
    UIImageView *navImage;
    IBOutlet HeaderView *vHeader;
    
    IBOutlet UILabel *pName;
    IBOutlet UILabel *pStatus_a;
    IBOutlet UILabel *pStatus_b;
    
    IBOutlet UITableView *profileTable;
    
    NSArray *sections;
    
    NSMutableIndexSet *expandedSections;
    
    NSArray *detailValues;
    NSArray *dependentValues;
}

@property (strong, nonatomic) NSArray *employeeData;
@property (strong, nonatomic) NSDictionary *employerData;
@property (nonatomic, assign) NSInteger  currentCoverageYearIndex;

@property (nonatomic, weak)id<EmployeeProfileDelegate> delegate;

@end

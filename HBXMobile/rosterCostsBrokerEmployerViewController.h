//
//  rosterCostsBrokerEmployerViewController.h
//  HBXMobile
//
//  Created by John Boyd on 9/15/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "brokerEmployersData.h"
#import "employerTabController.h"
#import "HeaderView.h"
#import "EmployeeProfileViewController.h"

@interface rosterCostsBrokerEmployerViewController : UIViewController <HeaderViewDelegate, EmployeeProfileDelegate>
{
    IBOutlet UITableView *pRosterTable;
    
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet HeaderView *vHeader;
    
    brokerEmployersData *employerData;
    UIImageView *navImage;
    
    NSArray *pArray;
    NSArray *sectionIndex;
    
    NSDictionary *dictionary;
    NSArray *rosterList;
    
    int enrollmentIndex;
}

@property(nonatomic, assign) NSString *enrollHost;
@property(nonatomic, assign) NSString *customCookie_a;

@end

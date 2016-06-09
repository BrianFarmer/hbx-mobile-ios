//
//  brokerPlanDetailViewController.h
//  HBXMobile
//
//  Created by David Boyd on 5/16/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrokerAccountViewController.h"

@interface brokerPlanDetailViewController : UIViewController <MFMessageComposeViewControllerDelegate>
{
    tabTypeItem *type;
    
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet UIView *vHeader;
    
    IBOutlet UITableView *myTable;
    IBOutlet UITabBar *myTabBar;
    
    NSArray *topSectionValues;
    NSArray *topSectionNames;
    
    NSArray *midSectionValues;
    NSArray *midSectionNames;
    
    int     globalFontSize;
    
}

@property (strong, nonatomic) tabTypeItem *type;
@property(nonatomic, assign) long bucket;


@end

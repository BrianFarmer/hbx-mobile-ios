//
//  brokerPlanDetailViewController.h
//  HBXMobile
//
//  Created by David Boyd on 5/16/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "brokerEmployersData.h"
#import "popupMessageBox.h"

@interface brokerPlanDetailViewController : UIViewController <MFMessageComposeViewControllerDelegate, popupMessageBoxDelegate>
{
    brokerEmployersData *type;
    
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet UIView *vHeader;
    
    IBOutlet UITableView *myTable;
//    IBOutlet UITabBar *myTabBar;
    
    NSArray *topSectionValues;
    NSArray *topSectionNames;
    
    NSArray *midSectionValues;
    NSArray *midSectionNames;
    
    int     globalFontSize;
//    BOOL    bPhoneSectionShowing;
    
    NSDictionary *dictionary;
    
    UIImageView *pView1;
    
}

@property (strong, nonatomic) brokerEmployersData *type;
@property(nonatomic, assign) long bucket;
@property(nonatomic, assign) NSString *enrollHost;
@property(nonatomic, assign) NSString *customCookie_a;

@end

//
//  rosterBrokerEmployerViewController.h
//  HBXMobile
//
//  Created by John Boyd on 9/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "brokerEmployersData.h"
#import "employerTabController.h"
#import "UISlideView.h"

@interface rosterBrokerEmployerViewController : UIViewController <uiSlideViewDelegate>
{
    IBOutlet UITableView *pRosterTable;
    
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet UIView *vHeader;

    brokerEmployersData *employerData;
    UIImageView *navImage;
    
    UISlideView *slideView;
    
    NSArray *pArray;
    NSArray *sectionIndex;
    
    NSDictionary *dictionary;
    NSArray *rosterList;
}

@property(nonatomic, assign) NSString *enrollHost;
@property(nonatomic, assign) NSString *customCookie_a;

@end

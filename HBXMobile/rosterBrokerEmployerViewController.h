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
#import "HeaderView.h"

@interface rosterBrokerEmployerViewController : UIViewController <uiSlideViewDelegate, HeaderViewDelegate>
{
    IBOutlet UITableView *pRosterTable;
    
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet HeaderView *vHeader;

    brokerEmployersData *employerData;
    UIImageView *navImage;
    
    UISlideView *slideView;
    
    NSArray *sectionIndex;
    
    NSDictionary *dictionary;
    NSArray *rosterList;
    
    NSArray *displayArray;
    
    BOOL bFilterOpen;
    BOOL bDataLoading;
}

@property(nonatomic, assign) NSString *enrollHost;
@property(nonatomic, assign) NSString *customCookie_a;

@end

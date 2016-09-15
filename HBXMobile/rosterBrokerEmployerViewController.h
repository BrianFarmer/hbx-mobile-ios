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

@interface rosterBrokerEmployerViewController : UIViewController
{
    IBOutlet UITableView *pRosterTable;
    
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet UIView *vHeader;

    brokerEmployersData *employerData;
    UIImageView *navImage;
}

@end

//
//  plansBrokerEmployerViewController.h
//  HBXMobile
//
//  Created by David Boyd on 9/20/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "brokerEmployersData.h"
#import "employerTabController.h"

@interface plansBrokerEmployerViewController : UIViewController
{
    UIPageControl *pageControl;
    
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet UIView *vHeader;
    
    brokerEmployersData *employerData;
    UIImageView *navImage;

}

@end
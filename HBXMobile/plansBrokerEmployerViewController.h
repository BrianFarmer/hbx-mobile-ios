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
#import "benefitGroupCardView.h"

@interface plansBrokerEmployerViewController : UIViewController <planCardViewDelegate>
{
    UIPageControl *pageControl;
    
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet UIView *vHeader;
    
    brokerEmployersData *employerData;
    UIImageView *navImage;
    
    UIScrollView  *scrollView;

}

@end

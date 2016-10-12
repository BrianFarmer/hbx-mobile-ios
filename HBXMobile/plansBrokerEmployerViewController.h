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
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "HeaderView.h"

@interface plansBrokerEmployerViewController : UIViewController <UIScrollViewDelegate, planCardViewDelegate>
{
    UIPageControl *pageControl;
//    UISegmentedControl *planYearControl;
    
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet HeaderView *vHeader;
    
    brokerEmployersData *employerData;
    UIImageView *navImage;
    
    UIScrollView  *scrollView;

}

@end

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

@interface plansBrokerEmployerViewController : UIViewController <UIScrollViewDelegate, planCardViewDelegate, HeaderViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UIPageControl *pageControl;
    
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet HeaderView *vHeader;
    
//    brokerEmployersData *employerData;
    UIImageView *navImage;
    
    UIScrollView  *scrollView;
    
    UITableView *planTable;
    
    NSMutableArray *_pd;
    
    //NSMutableArray *_planDetails;
    //NSMutableArray *_planDentalDetails;
    NSMutableIndexSet *expandedSections;

    NSArray *plans;
//    UISegmentedControl *planYearControl;
    NSInteger selectedSegmentIndex;
}

@end

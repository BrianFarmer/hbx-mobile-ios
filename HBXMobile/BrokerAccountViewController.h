//
//  BrokerAccountViewController.h
//  HBXMobile
//
//  Created by David Boyd on 5/9/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import <MessageUI/MessageUI.h>

typedef NS_ENUM(NSInteger, enrollmentState) {
    NEEDS_ATTENTION,
    OPEN_ENROLLMENT_MET,
    RENEWAL_IN_PROGRESS,
    NO_ACTION_REQUIRED
};

@interface tabTypeItem : NSObject
{
/*
    int         type;           //Used to show if detail page was expanded. Not used not becuase we are no longer showing detail drop down table row
    enrollmentState status;     //Used to differentiate between Need immediate action rows and open enrollment met.
    NSString    *companyName;
    NSString    *employeesSignedup;
    NSString    *employeesWaived;
    NSString    *planMinimum;
    NSString    *employeesTotal;
    NSString    *planEnrollmentStartDate;
    NSString    *planEnrollmentEndDate;
*/
 }

@property (nonatomic, assign) int type;
@property (nonatomic, assign) enrollmentState status;
@property (nonatomic, retain) NSString *companyName;
@property (nonatomic, retain) NSString *planYear;
@property (nonatomic, retain) NSString *employeesEnrolled;
@property (nonatomic, retain) NSString *employeesWaived;
@property (nonatomic, retain) NSString *planMinimum;
@property (nonatomic, retain) NSString *employeesTotal;
@property (nonatomic, retain) NSString *open_enrollment_begins;
@property (nonatomic, retain) NSString *open_enrollment_ends;
@property (nonatomic, retain) NSString *renewal_applicable_available;
@property (nonatomic, retain) NSString *renewal_application_due;
@property (nonatomic, retain) NSString *binder_payment_due;
@property (nonatomic, retain) NSString *total_premium;
@property (nonatomic, retain) NSString *employee_contribution;
@property (nonatomic, retain) NSString *employer_contribution;
@property (nonatomic, retain) NSString *employer_address_1;
@property (nonatomic, retain) NSString *employer_city;
@property (nonatomic, retain) NSString *employer_state;
@property (nonatomic, retain) NSString *employer_zip;
@end

@interface BrokerAccountViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate, MFMessageComposeViewControllerDelegate>
{
    IBOutlet UITableView *brokerTable;
    
    NSArray *pCompanies;
    NSArray *searchResults;
    NSMutableArray *searchData;
    
    IBOutlet UISearchBar *searchBar;
    UISearchController *searchController;
//    UISearchDisplayController *searchDisplayController;

    NSMutableIndexSet *expandedSections;
    NSMutableIndexSet *expandedCompanies;
    
    NSArray *sections;
    int clients_needing_immediate_attention;
    
    
    NSMutableArray *listOfCompanies;
    NSMutableArray *open_enrollment;
    NSMutableArray *renewals;
    NSMutableArray *all_others;
//    NSMutableArray *ao;
    
    NSMutableArray *ipath;
    
    NSDictionary *dictionary;
    NSArray *subscriberPlans;
}

//@property (strong, nonatomic) UISearchController *searchController;

//@property (nonatomic, strong) UIButton *searchButton;
//@property (nonatomic, strong) UIBarButtonItem *searchItem;
//@property (nonatomic, strong) UISearchBar *searchBar;


@end

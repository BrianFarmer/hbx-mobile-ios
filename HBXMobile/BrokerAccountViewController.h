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
#import "brokerSearchResultTableViewController.h"

typedef NS_ENUM(NSInteger, enrollmentState) {
    NEEDS_ATTENTION,
    OPEN_ENROLLMENT_MET,
    RENEWAL_IN_PROGRESS,
    NO_ACTION_REQUIRED
};

@interface tabTypeItem : NSObject

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
@property (nonatomic, retain) NSString *renewal_application_available;
@property (nonatomic, retain) NSString *renewal_application_due;
@property (nonatomic, retain) NSString *binder_payment_due;
@property (nonatomic, retain) NSString *total_premium;
@property (nonatomic, retain) NSString *employee_contribution;
@property (nonatomic, retain) NSString *employer_contribution;
@property (nonatomic, retain) NSString *employer_address_1;
@property (nonatomic, retain) NSString *employer_city;
@property (nonatomic, retain) NSString *employer_state;
@property (nonatomic, retain) NSString *employer_zip;
@property (nonatomic, retain) NSArray  *emails;
@property (nonatomic, retain) NSArray  *phones;
@property (nonatomic, retain) NSString *active_general_agency;
@end

@interface BrokerAccountViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate, MFMessageComposeViewControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, searchDelegate>
{
    IBOutlet UITableView *brokerTable;
    
    NSArray *pCompanies;
    NSArray *searchResults;
    NSMutableArray *searchData;
    
//    IBOutlet UISearchBar *searchBar;
//    UISearchController *searchController;
//    UISearchDisplayController *searchDisplayController;

    NSMutableIndexSet *expandedSections;
    NSMutableIndexSet *expandedCompanies;
    
    NSArray *sections;
    int clients_needing_immediate_attention;
    
    NSMutableArray *listOfCompanies;
    NSMutableArray *open_enrollment;
    NSMutableArray *renewals;
    NSMutableArray *all_others;
    
    NSDictionary *dictionary;
    NSArray *subscriberPlans;

    NSString *customCookie_a;
    NSString *_brokerId;
    
    NSString *enrollHost;
    
    UIBarButtonItem *searchButton;
    BOOL firstTime;
}

@property (strong, nonatomic) UISearchController *searchController;

//@property (nonatomic, strong) UIButton *searchButton;
//@property (nonatomic, strong) UIBarButtonItem *searchItem;
@property (nonatomic, strong) NSString *jsonData;
@property (nonatomic, strong) NSString *customCookie_a;
@property (nonatomic, strong) NSString *_brokerId;
@property (nonatomic, strong) NSString *enrollHost;
@property (nonatomic, weak) NSArray * displayedItems;

@end

//
//  BrokerAccountViewController.h
//  HBXMobile
//
//  Created by David Boyd on 5/9/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface tabTypeItem : NSObject
{
    int         type;
    NSString    *companyName;
    NSString    *employeesSignedup;
    NSString    *employeesWaived;
    NSString    *planMinimum;
    NSString    *employeesTotal;
    NSString    *planEnrollmentStartDate;
    NSString    *planEnrollmentEndDate;
}

@property (nonatomic, assign) int type;
@property (nonatomic, retain) NSString *companyName;
@property (nonatomic, retain) NSString *employeesEnrolled;
@property (nonatomic, retain) NSString *employeesWaived;
@property (nonatomic, retain) NSString *planMinimum;
@property (nonatomic, retain) NSString *employeesTotal;
@property (nonatomic, retain) NSString *planEnrollmentStartDate;
@property (nonatomic, retain) NSString *planEnrollmentEndDate;

@end

@interface BrokerAccountViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>
{
    IBOutlet UITableView *brokerTable;
    
    NSArray *pCompanies;
    NSArray *searchResults;
    NSMutableArray *searchData;
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;

    NSMutableIndexSet *expandedSections;
    NSMutableIndexSet *expandedCompanies;
    
    NSArray *sections;
    NSArray *companies;
    
    NSMutableArray *listOfCompanies;
    NSMutableArray *ia;
    NSMutableArray *oe;
    NSMutableArray *uoe;
    NSMutableArray *ao;
    
    NSMutableArray *ipath;
}

@property (strong, nonatomic) UISearchController *searchController;


@end

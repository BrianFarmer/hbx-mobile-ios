//
//  BrokerAccountTableViewController.h
//  HBXMobile
//
//  Created by David Boyd on 6/5/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import "MGSwipeTableCell.h"
#import "brokerSearchResultTableViewController.h"
#import "popupMessagebox.h"

@interface BrokerAccountTableViewController : UITableViewController <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, MFMessageComposeViewControllerDelegate, MGSwipeTableCellDelegate, searchDelegate, popupMessageBoxDelegate>
{
    NSMutableArray *searchData;
    
    NSMutableIndexSet *expandedSections;
    
    NSArray *sections;
    int total_active_clients;
    int clients_needing_immediate_attention;
    
    NSMutableArray *listOfCompanies;
    NSMutableArray *open_enrollment;
    NSMutableArray *renewals;
    NSMutableArray *all_others;
    
    NSDictionary *dictionary;
    NSArray *subscriberPlans;
    
    UIBarButtonItem *searchButton;
    BOOL firstTime;
    BOOL bAlreadyShownTutorial;
    
    UIImageView *pHeaderImage;
    BOOL bAddedOpenEnrollmentDivider;
    
    BOOL bAllClientsSortedByClient;
    BOOL bSortAscending;
    
    BOOL bUsesGIT;
}

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSArray *filteredProducts;
@property (nonatomic, strong) NSString *jsonData;
@property (nonatomic, strong) NSString *customCookie_a;
@property (nonatomic, strong) NSString *_brokerId;
@property (nonatomic, strong) NSString *enrollHost;

-(void)didSelectSearchItem:(id)tabType;

@end

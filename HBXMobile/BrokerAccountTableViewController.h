//
//  BrokerAccountTableViewController.h
//  HBXMobile
//
//  Created by David Boyd on 6/5/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "brokerSearchResultTableViewController.h"

@interface BrokerAccountTableViewController : UITableViewController <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, MGSwipeTableCellDelegate, searchDelegate>
{
    NSMutableArray *searchData;
    
    NSMutableIndexSet *expandedSections;
    
    NSArray *sections;
    int clients_needing_immediate_attention;
    
    NSMutableArray *listOfCompanies;
    NSMutableArray *open_enrollment;
    NSMutableArray *renewals;
    NSMutableArray *all_others;
    
    NSDictionary *dictionary;
    NSArray *subscriberPlans;
    
    UIBarButtonItem *searchButton;
    BOOL firstTime;
}

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSArray *filteredProducts;
@property (nonatomic, strong) NSString *jsonData;
@property (nonatomic, strong) NSString *customCookie_a;
@property (nonatomic, strong) NSString *_brokerId;
@property (nonatomic, strong) NSString *enrollHost;

-(void)didSelectSearchItem:(id)tabType;

@end

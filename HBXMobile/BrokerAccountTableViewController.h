//
//  BrokerAccountTableViewController.h
//  HBXMobile
//
//  Created by David Boyd on 7/5/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface BrokerAccountTableViewController : UITableViewController <MGSwipeTableCellDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

//@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSArray *filteredProducts;
@end

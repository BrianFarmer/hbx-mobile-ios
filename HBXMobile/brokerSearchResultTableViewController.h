//
//  brokerSearchResultTableViewController.h
//  HBXMobile
//
//  Created by David Boyd on 7/8/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface brokerSearchResultTableViewController : UITableViewController <MGSwipeTableCellDelegate>
{
    NSArray *sections;
}

@property (nonatomic, strong) NSArray *filteredProducts;

@end

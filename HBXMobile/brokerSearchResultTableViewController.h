//
//  brokerSearchResultTableViewController.h
//  HBXMobile
//
//  Created by David Boyd on 7/8/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import "MGSwipeTableCell.h"
#import "popupMessagebox.h"

@protocol searchDelegate

-(void)didSelectSearchItem:(id)tt;

@end

@interface brokerSearchResultTableViewController : UITableViewController <MGSwipeTableCellDelegate, popupMessageBoxDelegate, MFMessageComposeViewControllerDelegate>
{
    NSArray *sections;
    
    NSMutableIndexSet *expandedSections;
}

@property (nonatomic, strong) NSArray *filteredProducts;
@property (nonatomic, weak)id<searchDelegate> delegate;

@end

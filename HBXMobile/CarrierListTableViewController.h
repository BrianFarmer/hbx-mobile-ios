//
//  CarrierListTableViewController.h
//  HBXMobile
//
//  Created by John Boyd on 7/19/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarrierListTableViewController : UIViewController
{
    NSData *data;
    NSDictionary *dictionary;
    NSArray *carriers;
    
    IBOutlet UITableView *tblCarriers;
}

@end

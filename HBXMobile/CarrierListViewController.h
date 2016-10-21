//
//  CarrierListViewController.h
//  HBXMobile
//
//  Created by John Boyd on 7/19/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarrierListViewController : UIViewController
{
    NSData *data;
    NSDictionary *dictionary;
    NSArray *planTypes;
    
    IBOutlet UITableView *tblCarriers;
}

@end

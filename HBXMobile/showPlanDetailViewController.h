//
//  showPlanDetailViewController.h
//  HBXMobile
//
//  Created by David Boyd on 3/31/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showPlanDetailViewController : UIViewController
{
    IBOutlet UITableView *planDetailTable;
    IBOutlet UISegmentedControl *planType;
    
    NSMutableArray *detailData;
}

@end

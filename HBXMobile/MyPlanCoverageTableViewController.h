//
//  MyPlanCoverageTableViewController.h
//  HBXMobile
//
//  Created by David Boyd on 3/16/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlanCoverageTableViewController : UITableViewController
{
    BOOL    showCovered;
}

    @property (strong, nonatomic) NSString *covered;
    @property(nonatomic, assign) int type;
@end

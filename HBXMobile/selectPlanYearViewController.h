//
//  selectPlanYearViewController.h
//  HBXMobile
//
//  Created by John Boyd on 12/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectPlanYearViewController : UIViewController
{
    IBOutlet UITableView *messageTable;
}

@property (nonatomic, retain) NSString      *messageTitle;
@property (nonatomic, retain) NSArray       *messageArray;
@property (nonatomic, assign) int           messageType;
@property (nonatomic, retain) NSArray       *resultArray;
@property (nonatomic, assign) long           resultCode;

@end

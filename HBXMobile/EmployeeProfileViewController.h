//
//  EmployeeProfileViewController.h
//  HBXMobile
//
//  Created by David Boyd on 10/5/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeProfileViewController : UIViewController
{
    UIImageView *navImage;
    IBOutlet UIView *vHeader;
    
    IBOutlet UITableView *profileTable;
    
    NSArray *sections;
    
    NSMutableIndexSet *expandedSections;
}

@end

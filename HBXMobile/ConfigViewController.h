//
//  ConfigViewController.h
//  HBXMobile
//
//  Created by David Boyd on 6/10/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITableView *configTable;
    
    NSMutableArray *configTableNames;
    
    NSIndexPath   *checkedIndexPath;
    NSMutableIndexSet *expandedRow;
    NSMutableIndexSet *expandedCell;
    
    int eUseWhichServer;
}

//@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

@end

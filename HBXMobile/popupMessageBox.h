//
//  popupMessageBox.h
//  HBXMobile
//
//  Created by David Boyd on 7/13/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface popupMessageBox : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *messageTable;
}

@property (nonatomic, retain) NSString *messageTitle;
@property (nonatomic, retain) NSArray  *messageArray;

@end

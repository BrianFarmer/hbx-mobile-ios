//
//  hbxNotificationsTableViewController.h
//  HBXMobile
//
//  Created by David Boyd on 3/11/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hbxNotificationsTableViewController : UITableViewController
{
    NSArray *proofArray;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic, assign) int level;
@end

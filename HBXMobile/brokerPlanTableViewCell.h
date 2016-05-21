//
//  brokerPlanTableViewCell.h
//  HBXMobile
//
//  Created by David Boyd on 5/12/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface brokerPlanTableViewCell : UITableViewCell
{
    IBOutlet UILabel *employerLabel;
    IBOutlet UILabel *employeesLabel;
    IBOutlet UILabel *daysleftLabel;
    IBOutlet UILabel *lblEmployeesNeeded;
    IBOutlet UILabel *lblDaysLeftText;
}

@property (copy, nonatomic) NSString *employer;
@property (copy, nonatomic) NSString *employees;
@property (copy, nonatomic) NSString *daysleft;

@property (strong, nonatomic) IBOutlet UILabel *employerLabel;
@property (strong, nonatomic) IBOutlet UILabel *employeesLabel;
@property (strong, nonatomic) IBOutlet UILabel *daysleftLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblEmployeesNeeded;
@property (strong, nonatomic) IBOutlet UILabel *lblDaysLeftText;
@end

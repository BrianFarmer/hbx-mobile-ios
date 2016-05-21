//
//  brokerPlanTableViewCell.m
//  HBXMobile
//
//  Created by David Boyd on 5/12/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "brokerPlanTableViewCell.h"

@interface brokerPlanTableViewCell ()
//@property (strong, nonatomic) IBOutlet UILabel *employerLabel;
//@property (weak, nonatomic) IBOutlet UILabel *employeesLabel;
//@property (weak, nonatomic) IBOutlet UILabel *daysleftLabel;
@end

@implementation brokerPlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _employerLabel = [[UILabel alloc] initWithFrame:(CGRectMake(14, -6, 173, 49))];
        _employerLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
        _employerLabel.numberOfLines = 2;
        _employerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _employerLabel.textColor = [UIColor darkGrayColor];
        _employerLabel.textAlignment = NSTextAlignmentLeft;
        
        _employeesLabel = [[UILabel alloc] initWithFrame:(CGRectMake(180, 7, 40, 21))];
        _employeesLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
        _employeesLabel.textAlignment = NSTextAlignmentRight;
        _employeesLabel.textColor = [UIColor darkGrayColor];
        
        _lblEmployeesNeeded = [[UILabel alloc] initWithFrame:(CGRectMake(228, 3, 67, 35))];
        _lblEmployeesNeeded.font = [UIFont fontWithName:@"Roboto-Regular" size:11.0];
        _lblEmployeesNeeded.textAlignment = NSTextAlignmentLeft;
        _lblEmployeesNeeded.textColor = [UIColor darkGrayColor];
        _lblEmployeesNeeded.lineBreakMode = NSLineBreakByWordWrapping;
        _lblEmployeesNeeded.numberOfLines = 2;
        
        _daysleftLabel = [[UILabel alloc] initWithFrame:(CGRectMake(294, 8, 40, 21))];
        _daysleftLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
        _daysleftLabel.textAlignment = NSTextAlignmentRight;
        _daysleftLabel.textColor = [UIColor darkGrayColor];
        
        _lblDaysLeftText = [[UILabel alloc] initWithFrame:(CGRectMake(342, 3, 30, 34))];
        _lblDaysLeftText.font = [UIFont fontWithName:@"Roboto-Regular" size:11.0];
        _lblDaysLeftText.textAlignment = NSTextAlignmentLeft;
        _lblDaysLeftText.textColor = [UIColor darkGrayColor];
        _lblDaysLeftText.lineBreakMode = NSLineBreakByWordWrapping;
        _lblDaysLeftText.numberOfLines = 2;

        [self.contentView addSubview:_employerLabel];
        [self.contentView addSubview:_employeesLabel];
        [self.contentView addSubview:_lblEmployeesNeeded];
        [self.contentView addSubview:_daysleftLabel];
        [self.contentView addSubview:_lblDaysLeftText];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEmployer:(NSString *)employer {
    if (_employer != employer) {
        _employer = [employer copy];
        _employerLabel.text =_employer;
//        _employerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    }
}

- (void)setEmployees:(NSString *)employees {
    if (_employees != employees) {
        _employees = [employees copy];
        _employeesLabel.text =_employees;
//        _employeesLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
}

- (void)setDaysleft:(NSString *)daysleft {
    if (_daysleft != daysleft) {
        _daysleft = [daysleft copy];
        _daysleftLabel.text =_daysleft;
//        _daysleftLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
}


@end

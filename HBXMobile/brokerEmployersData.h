//
//  brokerEmployersData.h
//  HBXMobile
//
//  Created by David Boyd on 7/12/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, enrollmentState) {
    NEEDS_ATTENTION,
    OPEN_ENROLLMENT_MET,
    RENEWAL_IN_PROGRESS,
    NO_ACTION_REQUIRED
};

@interface brokerEmployersData : NSObject

@property (nonatomic, assign) int type;
@property (nonatomic, assign) enrollmentState status;
@property (nonatomic, retain) NSString *companyName;
@property (nonatomic, retain) NSString *planYear;
@property (nonatomic, retain) NSString *billing_report_date;
@property (nonatomic, retain) NSString *employeesEnrolled;
@property (nonatomic, retain) NSString *employeesWaived;
@property (nonatomic, retain) NSString *planMinimum;
@property (nonatomic, retain) NSString *employeesTotal;
@property (nonatomic, retain) NSString *open_enrollment_begins;
@property (nonatomic, retain) NSString *open_enrollment_ends;
@property (nonatomic, retain) NSString *renewal_application_available;
@property (nonatomic, retain) NSString *renewal_application_due;
@property (nonatomic, retain) NSString *binder_payment_due;
//@property (nonatomic, retain) NSString *total_premium;
//@property (nonatomic, retain) NSString *employee_contribution;
//@property (nonatomic, retain) NSString *employer_contribution;
//@property (nonatomic, retain) NSString *employer_address_1;
//@property (nonatomic, retain) NSString *employer_city;
//@property (nonatomic, retain) NSString *employer_state;
//@property (nonatomic, retain) NSString *employer_zip;
@property (nonatomic, retain) NSArray  *emails;
//@property (nonatomic, retain) NSArray  *phones;
@property (nonatomic, retain) NSString *active_general_agency;
@property (nonatomic, retain) NSArray  *contact_info;
@property (nonatomic, retain) NSString *detail_url;
@property (nonatomic, retain) NSString *roster_url;
@end

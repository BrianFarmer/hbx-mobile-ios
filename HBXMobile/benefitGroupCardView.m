//
//  benefitGroupCardView.m
//  HBXMobile
//
//  Created by David Boyd on 9/20/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "benefitGroupCardView.h"

@implementation benefitGroupCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor greenColor];
        
        NSLog(@"%@", _benefitGroupName);
    }
    return self;
}

-(void)layoutView
{
    UILabel *lblBenefitGroup = [[UILabel alloc] initWithFrame:CGRectMake(5,5,100, 20)];
    lblBenefitGroup.text = @"BENEFIT GROUP ";
    
    UILabel *lblBenefitGroupName = [[UILabel alloc] initWithFrame:CGRectMake(5,45,100, 20)];
    lblBenefitGroupName.text = @"BENEFIT GROUP ";

    UILabel *lblPlans = [[UILabel alloc] initWithFrame:CGRectMake(5,85,100, 20)];
    lblPlans.text = @"PLANS OFFERED";

    UILabel *lblPlansName = [[UILabel alloc] initWithFrame:CGRectMake(5,105,100, 20)];
    lblPlansName.text = @"ALL Kaiser plans (any Metal Level)";

    UILabel *lblEligibility= [[UILabel alloc] initWithFrame:CGRectMake(5,145,100, 20)];
    lblEligibility.text = @"ELIGIBILITY ";

    UILabel *lblEligibilityText = [[UILabel alloc] initWithFrame:CGRectMake(5,185,100, 20)];
    lblEligibilityText.text = @"First of the month following or coiciding with data of hire.";

    UILabel *lblContribution = [[UILabel alloc] initWithFrame:CGRectMake(5,225,100, 20)];
    lblContribution.text = @"CONTRIBUTION LEVELS";


    UILabel *lblContributionEmployee = [[UILabel alloc] initWithFrame:CGRectMake(5,265,100, 20)];
    lblContributionEmployee.text = @"80%";
    UILabel *lblContributionSpouse = [[UILabel alloc] initWithFrame:CGRectMake(105,265,100, 20)];
    lblContributionSpouse.text = @"20%";
    UILabel *lblContributionPartner = [[UILabel alloc] initWithFrame:CGRectMake(205,265,100, 20)];
    lblContributionPartner.text = @"10%";
    UILabel *lblContributionChild = [[UILabel alloc] initWithFrame:CGRectMake(305,265,100, 20)];
    lblContributionChild.text = @"10%";


    UILabel *lblReference = [[UILabel alloc] initWithFrame:CGRectMake(5,305,100, 20)];
    lblReference.text = @"REFERENCE PLAN";

    UILabel *lblReferenceText = [[UILabel alloc] initWithFrame:CGRectMake(5,345,100, 20)];
    lblReferenceText.text = @"KP DC Silver 2000/35/Dental";
}
@end

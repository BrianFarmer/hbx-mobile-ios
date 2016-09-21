//
//  benefitGroupCardView.m
//  HBXMobile
//
//  Created by David Boyd on 9/20/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "benefitGroupCardView.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

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
        
        self.backgroundColor = [UIColor whiteColor];
        
        NSLog(@"%@", _benefitGroupName);
    }
    return self;
}

-(void)layoutView
{
    UILabel *lblBenefitGroup = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 20)];
    lblBenefitGroup.text = @"BENEFIT GROUP ";
    lblBenefitGroup.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblBenefitGroup.textColor = UIColorFromRGB(0x555555);
    [lblBenefitGroup sizeToFit];
    [self addSubview:lblBenefitGroup];
    
    UILabel *lblBenefitGroupName = [[UILabel alloc] initWithFrame:CGRectMake(5,25,150, 20)];
    lblBenefitGroupName.text = @"CEO's & Managers";
    lblBenefitGroupName.font = [UIFont fontWithName:@"Roboto-Bold" size:18.0f];
    lblBenefitGroupName.textColor = UIColorFromRGB(0x555555);
    [lblBenefitGroupName sizeToFit];
    [self addSubview:lblBenefitGroupName];
    
    UILabel *lblPlans = [[UILabel alloc] initWithFrame:CGRectMake(5,85,150, 20)];
    lblPlans.text = @"PLANS OFFERED";
    lblPlans.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblPlans.textColor = UIColorFromRGB(0x555555);
    [lblPlans sizeToFit];
    [self addSubview:lblPlans];
    
    UILabel *lblPlansName = [[UILabel alloc] initWithFrame:CGRectMake(5,105,150, 20)];
    lblPlansName.text = @"ALL Kaiser plans (any Metal Level)";
    lblPlansName.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0f];
    lblPlansName.textColor = UIColorFromRGB(0x555555);
    [lblPlansName sizeToFit];
    [self addSubview:lblPlansName];
    
    UILabel *lblEligibility= [[UILabel alloc] initWithFrame:CGRectMake(5,145,100, 20)];
    lblEligibility.text = @"ELIGIBILITY ";
    lblEligibility.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblEligibility.textColor = UIColorFromRGB(0x555555);
    [lblEligibility sizeToFit];
    [self addSubview:lblEligibility];
    
    UILabel *lblEligibilityText = [[UILabel alloc] initWithFrame:CGRectMake(5,165,100, 20)];
    lblEligibilityText.text = @"First of the month following or coiciding with data of hire.";
    lblEligibilityText.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0f];
    lblEligibilityText.textColor = UIColorFromRGB(0x555555);
    [lblEligibilityText sizeToFit];
    [self addSubview:lblEligibilityText];
    
    UILabel *lblContribution = [[UILabel alloc] initWithFrame:CGRectMake(5,205,100, 20)];
    lblContribution.text = @"CONTRIBUTION LEVELS";
    lblContribution.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblContribution.textColor = UIColorFromRGB(0x555555);
    [lblContribution sizeToFit];
    [self addSubview:lblContribution];

    
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x00a3e2) };
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"80" attributes:attrs];
    
    [attributedTitle beginEditing];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:32.0] range:NSMakeRange(0, attributedTitle.length)];
    [attributedTitle endEditing];

    NSMutableAttributedString *attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:@"%\n" attributes:attrs];
    
    [attributedTitle1 beginEditing];
    [attributedTitle1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:18] range:NSMakeRange(0, attributedTitle1.length)];
    [attributedTitle1 endEditing];
    
    NSMutableAttributedString *attributedTitle2 = [[NSMutableAttributedString alloc] initWithString:@"EMPLOYEE" attributes:attrs];
    
    [attributedTitle2 beginEditing];
    [attributedTitle2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:16] range:NSMakeRange(0, attributedTitle2.length)];
    [attributedTitle2 endEditing];
    
    [attributedTitle appendAttributedString:attributedTitle1];
    [attributedTitle appendAttributedString:attributedTitle2];
    
    UILabel *lblContributionEmployee = [[UILabel alloc] initWithFrame:CGRectMake(5,225,100, 20)];
    lblContributionEmployee.attributedText =  attributedTitle;
    lblContributionEmployee.numberOfLines = 2;
    lblContributionEmployee.textAlignment = NSTextAlignmentCenter;
    [lblContributionEmployee sizeToFit];
    [self addSubview:lblContributionEmployee];
    
    
    attrs = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x00a99e) };
    attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"20" attributes:attrs];
    
    [attributedTitle beginEditing];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:32.0] range:NSMakeRange(0, attributedTitle.length)];
    [attributedTitle endEditing];
    
    attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:@"%\n" attributes:attrs];
    
    [attributedTitle1 beginEditing];
    [attributedTitle1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:18] range:NSMakeRange(0, attributedTitle1.length)];
    [attributedTitle1 endEditing];
    
    attributedTitle2 = [[NSMutableAttributedString alloc] initWithString:@"SPOUSE" attributes:attrs];
    
    [attributedTitle2 beginEditing];
    [attributedTitle2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:16] range:NSMakeRange(0, attributedTitle2.length)];
    [attributedTitle2 endEditing];
    
    [attributedTitle appendAttributedString:attributedTitle1];
    [attributedTitle appendAttributedString:attributedTitle2];
    
    
    UILabel *lblContributionSpouse = [[UILabel alloc] initWithFrame:CGRectMake(100,225,100, 20)];
    lblContributionSpouse.attributedText =  attributedTitle;
    lblContributionSpouse.numberOfLines = 2;
    lblContributionSpouse.textAlignment = NSTextAlignmentCenter;
    [lblContributionSpouse sizeToFit];
    [self addSubview:lblContributionSpouse];
    
    
    
    attrs = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x625ba8) };
    attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"10" attributes:attrs];
    
    [attributedTitle beginEditing];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:32.0] range:NSMakeRange(0, attributedTitle.length)];
    [attributedTitle endEditing];
    
    attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:@"%\n" attributes:attrs];
    
    [attributedTitle1 beginEditing];
    [attributedTitle1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:18] range:NSMakeRange(0, attributedTitle1.length)];
    [attributedTitle1 endEditing];
    
    attributedTitle2 = [[NSMutableAttributedString alloc] initWithString:@"DOMESTIC\nPARTNER" attributes:attrs];
    
    [attributedTitle2 beginEditing];
    [attributedTitle2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:16] range:NSMakeRange(0, attributedTitle2.length)];
    [attributedTitle2 endEditing];
    
    [attributedTitle appendAttributedString:attributedTitle1];
    [attributedTitle appendAttributedString:attributedTitle2];

    UILabel *lblContributionPartner = [[UILabel alloc] initWithFrame:CGRectMake(180,225,100, 20)];
    lblContributionPartner.attributedText =  attributedTitle;
    lblContributionPartner.numberOfLines = 3;
    lblContributionPartner.textAlignment = NSTextAlignmentCenter;
    [lblContributionPartner sizeToFit];
    [self addSubview:lblContributionPartner];
    
    
    attrs = @{ NSForegroundColorAttributeName : UIColorFromRGB(0xf06eaa) };
    attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"10" attributes:attrs];
    
    [attributedTitle beginEditing];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:32.0] range:NSMakeRange(0, attributedTitle.length)];
    [attributedTitle endEditing];
    
    attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:@"%\n" attributes:attrs];
    
    [attributedTitle1 beginEditing];
    [attributedTitle1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:18] range:NSMakeRange(0, attributedTitle1.length)];
    [attributedTitle1 endEditing];
    
    attributedTitle2 = [[NSMutableAttributedString alloc] initWithString:@"CHILD <26" attributes:attrs];
    
    [attributedTitle2 beginEditing];
    [attributedTitle2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:16] range:NSMakeRange(0, attributedTitle2.length)];
    [attributedTitle2 endEditing];
    
    [attributedTitle appendAttributedString:attributedTitle1];
    [attributedTitle appendAttributedString:attributedTitle2];
    
    
    UILabel *lblContributionChild = [[UILabel alloc] initWithFrame:CGRectMake(270,225,100, 20)];
    lblContributionChild.attributedText =  attributedTitle;
    lblContributionChild.numberOfLines = 2;
    lblContributionChild.textAlignment = NSTextAlignmentCenter;
    [lblContributionChild sizeToFit];
    [self addSubview:lblContributionChild];

    UILabel *lblReference = [[UILabel alloc] initWithFrame:CGRectMake(5,315,100, 20)];
    lblReference.text = @"REFERENCE PLAN";
    lblReference.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblReference.textColor = UIColorFromRGB(0x555555);
        [lblReference sizeToFit];
    [self addSubview:lblReference];
    
    UILabel *lblReferenceText = [[UILabel alloc] initWithFrame:CGRectMake(5,335,100, 20)];
    lblReferenceText.text = @"KP DC Silver 2000/35/Dental";
    lblReferenceText.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0f];
    lblReferenceText.textColor = UIColorFromRGB(0x555555);
        [lblReferenceText sizeToFit];
    [self addSubview:lblReferenceText];
}
@end

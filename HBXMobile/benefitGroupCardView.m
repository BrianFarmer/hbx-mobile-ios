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
        self.clipsToBounds = TRUE;
        
        NSLog(@"%@", _benefitGroupName);
    }
    return self;
}

-(void)userTappedOnPageNo:(UIGestureRecognizer*)sender
{
    if (currrentCard == 3)
        [_delegate scrolltoNextPage:0];
    else
        [_delegate scrolltoNextPage:currrentCard];
}

-(void)layoutView:(int)cc totalPages:(int)totalCards
{
    NSLog(@"W:%f     H:%f", self.bounds.size.width, self.bounds.size.height);
    CGFloat scaleX = self.frame.size.width/394;
    CGFloat scaleY = self.frame.size.height/448;
    CGFloat scale = MIN(scaleX, scaleY);

    CGFloat mscale = [UIScreen mainScreen].scale;
    
//    UIView *_innerView = [[UIView alloc] initWithFrame:self.bounds];
//    _innerView.clipsToBounds = YES;
//    [self addSubview:_innerView];
    
    currrentCard = cc;
    UILabel *lblBenefitGroup = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    lblBenefitGroup.text = @"BENEFIT GROUP ";
    lblBenefitGroup.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblBenefitGroup.textColor = UIColorFromRGB(0x555555);
    [lblBenefitGroup sizeToFit];
    [self addSubview:lblBenefitGroup];
    
    UILabel *lblPageNo = [[UILabel alloc] initWithFrame:CGRectMake(lblBenefitGroup.frame.origin.x + lblBenefitGroup.frame.size.width + 5, 5, 150, 20)];
    lblPageNo.text = [NSString stringWithFormat:@"(%d/%d)", currrentCard, totalCards];
    lblPageNo.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblPageNo.textColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]; //UIColorFromRGB(0x555555);
    [lblPageNo sizeToFit];
    [self addSubview:lblPageNo];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnPageNo:)];
    [lblPageNo setUserInteractionEnabled:YES];
    [lblPageNo addGestureRecognizer:gesture];

    UILabel *lblBenefitGroupName = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 150, 20)];
    lblBenefitGroupName.text = @"CEO's & Managers";
    lblBenefitGroupName.font = [UIFont fontWithName:@"Roboto-Regular" size:20.0f];
    lblBenefitGroupName.textColor = UIColorFromRGB(0x555555);
    [lblBenefitGroupName sizeToFit];
    [self addSubview:lblBenefitGroupName];
    
    UILabel *lblPlans = [[UILabel alloc] initWithFrame:CGRectMake(10,85,150, 20)];
    lblPlans.text = @"PLANS OFFERED";
    lblPlans.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblPlans.textColor = UIColorFromRGB(0x555555);
    [lblPlans sizeToFit];
    [self addSubview:lblPlans];
    
    UILabel *lblPlansName = [[UILabel alloc] initWithFrame:CGRectMake(10,105,150, 20)];
    lblPlansName.text = @"ALL Kaiser plans (any Metal Level)";
    lblPlansName.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0f];
    lblPlansName.textColor = UIColorFromRGB(0x555555);
    [lblPlansName sizeToFit];
    [self addSubview:lblPlansName];
    
    UILabel *lblEligibility= [[UILabel alloc] initWithFrame:CGRectMake(10,155,100, 20)];
    lblEligibility.text = @"ELIGIBILITY ";
    lblEligibility.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblEligibility.textColor = UIColorFromRGB(0x555555);
    [lblEligibility sizeToFit];
    [self addSubview:lblEligibility];
    
    UILabel *lblEligibilityText = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, self.frame.size.width - 10, 20)];
    lblEligibilityText.text = @"First of the month following or coiciding with data of hire.";
    lblEligibilityText.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0f];
    lblEligibilityText.textColor = UIColorFromRGB(0x555555);
    lblEligibilityText.numberOfLines = 2;
    [lblEligibilityText sizeToFit];
    [self addSubview:lblEligibilityText];
    
    UILabel *lblContribution = [[UILabel alloc] initWithFrame:CGRectMake(10,235,100, 20)];
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
    
    UILabel *lblContributionEmployee = [[UILabel alloc] initWithFrame:CGRectMake(10,260,100, 20)];
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
    
    
    UILabel *lblContributionSpouse = [[UILabel alloc] initWithFrame:CGRectMake(100,260,100, 20)];
    lblContributionSpouse.attributedText =  attributedTitle;
    lblContributionSpouse.numberOfLines = 2;
    lblContributionSpouse.textAlignment = NSTextAlignmentCenter;
    [lblContributionSpouse sizeToFit];
//    lblContributionSpouse.frame = CGRectMake(180,225,lblContributionSpouse.frame.size.width, lblContributionSpouse.frame.size.height);

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

    UILabel *lblContributionPartner = [[UILabel alloc] initWithFrame:CGRectMake(180,260,100, 20)];
    lblContributionPartner.attributedText =  attributedTitle;
    lblContributionPartner.numberOfLines = 3;
    lblContributionPartner.textAlignment = NSTextAlignmentCenter;
//    lblContributionPartner.adjustsFontSizeToFitWidth=YES;
//    lblContributionPartner.minimumScaleFactor=0.5;
    [lblContributionPartner sizeToFit];
//    lblContributionPartner.backgroundColor = [UIColor grayColor];
    
 //   lblContributionPartner.frame = CGRectMake(180,225,lblContributionPartner.frame.size.width, lblContributionPartner.frame.size.height);
    [self addSubview:lblContributionPartner];
/*
    CGSize maximumSize = CGSizeMake(300, 9999);
    NSString *dateString = @"The date today is January 1st, 1999";
    UIFont *dateFont = [UIFont fontWithName:@"Roboto-Bold" size:16];
//    CGSize dateStringSize = [attributedTitle sizeWithFont:dateFont
//                                   constrainedToSize:maximumSize
//                                       lineBreakMode:lblContributionPartner.lineBreakMode];
    int ih = [attributedTitle boundingRectWithSize:lblContributionPartner.frame.size
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil].size.height;

    CGRect dateFrame = CGRectMake(180,225,lblContributionPartner.frame.size.width, 50);
    
    lblContributionPartner.frame = dateFrame;
  */
    
    
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
    
    
    UILabel *lblContributionChild = [[UILabel alloc] initWithFrame:CGRectMake(270, 260, 100, 20)];
    lblContributionChild.attributedText =  attributedTitle;
    lblContributionChild.numberOfLines = 2;
    lblContributionChild.textAlignment = NSTextAlignmentCenter;

//        lblContributionChild.backgroundColor = [UIColor grayColor];
//    lblContributionChild.adjustsFontSizeToFitWidth=YES;
//    lblContributionChild.minimumScaleFactor=0.5;
    [lblContributionChild sizeToFit];
//    lblContributionChild.frame = CGRectMake(270,225,lblContributionChild.frame.size.width, lblContributionChild.frame.size.height);
    
    [self addSubview:lblContributionChild];
    
    
    int uu = self.frame.origin.y + self.frame.size.height;// - 40;
    
    UILabel *lblReference = [[UILabel alloc] initWithFrame:CGRectMake(10,375,100, 20)];
    lblReference.text = @"REFERENCE PLAN";
    lblReference.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblReference.textColor = UIColorFromRGB(0x555555);
        [lblReference sizeToFit];
    [self addSubview:lblReference];
    
    UILabel *lblReferenceText = [[UILabel alloc] initWithFrame:CGRectMake(10,395,100, 20)];
    lblReferenceText.text = @"KP DC Silver 2000/35/Dental";
    lblReferenceText.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0f];
    lblReferenceText.textColor = UIColorFromRGB(0x555555);
        [lblReferenceText sizeToFit];
    [self addSubview:lblReferenceText];

    
//    [self layer].anchorPoint = CGPointMake(0.0f, 0.0f);
//    self.transform = CGAffineTransformMakeScale(2, 2);
    
    if (scale < 1)
    {
        for (UIView *subview in [self subviews]) {
            subview.transform = CGAffineTransformMakeScale(scale+.15, scale+.15); //CGAffineTransformScale(CGAffineTransformIdentity, scale+.10, scale+.10);
            NSLog(@"%f\n", subview.frame.origin.x);
            
            if (subview.frame.origin.x < 75)
                subview.frame = CGRectMake(10,subview.frame.origin.y*scaleY, subview.frame.size.width, subview.frame.size.height);
            else
                subview.frame = CGRectMake(subview.frame.origin.x,subview.frame.origin.y*scaleY, subview.frame.size.width, subview.frame.size.height);
        
        }
    }

 
 /*
    lblContributionEmployee.transform = CGAffineTransformScale(CGAffineTransformIdentity, fScale, fScale);
    lblContributionSpouse.transform = CGAffineTransformScale(CGAffineTransformIdentity, fScale, fScale);
    lblContributionPartner.transform = CGAffineTransformScale(CGAffineTransformIdentity, fScale, fScale);
    lblContributionChild.transform = CGAffineTransformScale(CGAffineTransformIdentity, fScale, fScale);
*/
    [self evenlySpaceTheseButtonsInThisView:@[lblContributionEmployee, lblContributionSpouse, lblContributionPartner, lblContributionChild] :self];

}

- (void) evenlySpaceTheseButtonsInThisView : (NSArray *) buttonArray : (UIView *) thisView {
    int widthOfAllButtons = 0;
    for (int i = 0; i < buttonArray.count; i++) {
        UILabel *thisButton = [buttonArray objectAtIndex:i];
        //    [thisButton setCenter:CGPointMake(0, thisView.frame.size.height / 2.0)];
        widthOfAllButtons = widthOfAllButtons + thisButton.frame.size.width;
    }
    
    int spaceBetweenButtons = (thisView.frame.size.width - widthOfAllButtons) / (buttonArray.count + 1);
    
    UILabel *lastButton = nil;
    for (int i = 0; i < buttonArray.count; i++) {
        UILabel *thisButton = [buttonArray objectAtIndex:i];
        if (lastButton == nil) {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        } else {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons + lastButton.frame.origin.x + lastButton.frame.size.width, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        }
        
        lastButton = thisButton;
    }
    
}

@end

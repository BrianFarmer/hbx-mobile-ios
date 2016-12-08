//
//  HeaderView.m
//  HBXMobile
//
//  Created by John Boyd on 10/12/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "HeaderView.h"
#import "Constants.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation HeaderView

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
        
        NSLog(@"%@", @"HERE");
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];

    // commenters report the next line causes infinite recursion, so removing it
    // [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:self options:nil];
 //   [self addSubview:self.view];
}

- (void)layoutHeaderView:(NSDictionary *)eData
{
    [self layoutHeaderView:eData showcoverage:YES showplanyear:NO];
}

///- (void)layoutHeaderView:(brokerEmployersData *)eData showcoverage:(BOOL)bShowCoverage showplanyear:(BOOL)bShowPlanYear
- (void)layoutHeaderView:(NSDictionary *)eData showcoverage:(BOOL)bShowCoverage showplanyear:(BOOL)bShowPlanYear
{
    [self layoutHeaderView:eData showcoverage:YES showplanyear:NO showcontactbuttons:YES];
}

- (void)layoutHeaderView:(NSDictionary *)eData showcoverage:(BOOL)bShowCoverage showplanyear:(BOOL)bShowPlanYear showcontactbuttons:(BOOL)bShowContactButtons
{
//    employerData = eData;
    employerDetail = eData;
/*
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 3.0;
*/
    UILabel *pCompany = [[UILabel alloc] init];
    
    pCompany.font = [UIFont fontWithName:@"Roboto-Bold" size:24];
    pCompany.text = [eData valueForKey:@"employer_name"];
    pCompany.textColor = APPLICATION_DEFAULT_TEXT_COLOR;
    pCompany.numberOfLines = 0;
    
    pCompany.textAlignment = NSTextAlignmentCenter;
//    [pCompany sizeToFit];
    pCompany.frame = CGRectMake(10, 0, self.frame.size.width-20, 40);
  
    CGSize labelSize = CGSizeMake(200.0, 20.0);
    UIFont *cellFont = [UIFont fontWithName:@"Roboto-Bold" size:24];
    
    int iOffset = 0;
    
    if ([pCompany.text length] > 0)
        labelSize = [pCompany.text sizeWithFont: cellFont constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
    
    if (labelSize.height > 40)
    {
        pCompany.frame = CGRectMake(10, 0, self.frame.size.width-20, labelSize.height - 30);
        if (labelSize.height > 65)
            iOffset = 10;
    }
    
    UILabel *pCompanyFooter = [[UILabel alloc] init];
    pCompanyFooter.font = [UIFont fontWithName:@"Roboto-Medium" size:16];
   
    UILabel * pLabelCoverage;
    
    if (bShowCoverage)
    {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
        
        NSArray *pPlan = [[eData valueForKey:@"plan_years"] objectAtIndex:_iCurrentPlanIndex];
//        NSArray *pPlan = [employerData.plans objectAtIndex:_iCurrentPlanIndex];
        
        //                     NSDate *planYearBegins = [self userVisibleDateTimeForRFC3339Date:[pPlan valueForKey:@"plan_year_begins"] ];
        
 //       NSDate *planYear = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"]];
        
        
        NSDate *endDate = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"]];                 //[dictionary valueForKey:@"plan_year_begins"]]; //[f dateFromString:type.billing_report_date];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:364];
        NSDate *targetDate = [gregorian dateByAddingComponents:dateComponents toDate:endDate  options:0];
        
        [f setDateFormat:@"MMM dd, yyyy"];
        
//        UILabel *pLabelCoverage = [[UILabel alloc] initWithFrame:CGRectMake(0,[self viewWithTag:30].frame.origin.y + [self viewWithTag:30].frame.size.height,self.frame.size.width, 45)];
        pLabelCoverage = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-110, pCompany.frame.origin.y + pCompany.frame.size.height - iOffset, 220, 45)];
        pLabelCoverage.tag = 975;
        
        pLabelCoverage.numberOfLines = 2;
        pLabelCoverage.backgroundColor = [UIColor clearColor];
        pLabelCoverage.font = [UIFont fontWithName:@"Roboto-Medium" size:15];
        pLabelCoverage.textAlignment = NSTextAlignmentCenter;
        pLabelCoverage.textColor = APPLICATION_DEFAULT_TEXT_COLOR;
        
        pLabelCoverage.hidden = FALSE;
        NSString *lblCoverageYear;
        
        if ([[eData valueForKey:@"plan_years"] count] > 1)
            lblCoverageYear = [NSString stringWithFormat:@"%@ - %@  \u25BE\n", [[f stringFromDate:endDate] uppercaseString], [[f stringFromDate:targetDate] uppercaseString]];
        else
            lblCoverageYear = [NSString stringWithFormat:@"%@ - %@\n", [[f stringFromDate:endDate] uppercaseString], [[f stringFromDate:targetDate] uppercaseString]];
        
            
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : APPLICATION_DEFAULT_TEXT_COLOR };
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:lblCoverageYear attributes:attrs];
        
//        NSString *temp_a = @"Coverage Year \u25BE";
        NSString *temp_a = @"Coverage Year";
        
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:temp_a attributes:attrs];
        [string1 beginEditing];
        [string1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Medium" size:15.0] range:NSMakeRange(0, string1.length)];
        [string1 endEditing];
        
        [attributedTitle appendAttributedString:string1];
        
        pLabelCoverage.attributedText = attributedTitle;
        
 //       [self addSubview:pLabelCoverage];
        
        UIButton *coverageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-110, pCompany.frame.origin.y + pCompany.frame.size.height - iOffset, 220, 45)]; //pCompany.frame.origin.y + pCompany.frame.size.height - 140
        [coverageButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
        
        coverageButton.layer.cornerRadius = 10;
        coverageButton.clipsToBounds = YES;
        coverageButton.tag = 99;
        
        coverageButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        coverageButton.titleLabel.numberOfLines = 2;
        coverageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
  //      coverageButton.layer.borderWidth = 2.0f;
  //      coverageButton.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1].CGColor;
        coverageButton.backgroundColor = UIColorFromRGB(0xE0FFFF); //0xBFEFFF);//  [UIColor clearColor];

        coverageButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:15];
        coverageButton.tintColor = [UIColor purpleColor];
        [coverageButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];

        [coverageButton addTarget:self action:@selector(changeCoverageYear:) forControlEvents:UIControlEventTouchUpInside];

        if ([[eData valueForKey:@"plan_years"] count] > 1)
        {
            [self addSubview:coverageButton];
            pCompanyFooter.frame = CGRectMake(10, coverageButton.frame.origin.y + coverageButton.frame.size.height - iOffset/2, self.frame.size.width - 20, 20);
        }
        else
        {
            [self addSubview:pLabelCoverage];
            pCompanyFooter.frame = CGRectMake(10, pLabelCoverage.frame.origin.y + pLabelCoverage.frame.size.height - iOffset/2, self.frame.size.width - 20, 20);
        }
        

    }
    else
        pCompanyFooter.frame = CGRectMake(10, pCompany.frame.origin.y + pCompany.frame.size.height, self.frame.size.width - 20, pCompanyFooter.frame.size.height);

    
    pCompanyFooter.textAlignment = NSTextAlignmentCenter;
    pCompanyFooter.textColor = UIColorFromRGB(0x555555);
//    pCompany.backgroundColor  = [UIColor greenColor];
    
    enrollmentState eState = [self getEnrollmentState:eData];
    
    //if (employerData.status == (enrollmentState)NEEDS_ATTENTION)
    if (eState == (enrollmentState)NEEDS_ATTENTION)
    {
        pCompanyFooter.text = NSLocalizedString(@"TITLE_NOTE", @"OPEN ENROLLMENT IN PROGRESS - MINIMUM NOT MET");
        pCompanyFooter.textColor = ENROLLMENT_STATUS_OE_MIN_NOTMET;
        
    }
    else if (eState == (enrollmentState)OPEN_ENROLLMENT_MET)
    {
        pCompanyFooter.text = @"OPEN ENROLLMENT IN PROGRESS";
        pCompanyFooter.textColor = ENROLLMENT_STATUS_OE_MIN_MET;//[UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f]; //[UIColor yellowColor];
        
    }
    else if (eState == (enrollmentState)RENEWAL_IN_PROGRESS)
    {
        pCompanyFooter.text = @"RENEWAL PENDING"; //@"RENEWAL IN PROGRESS";
        pCompanyFooter.textColor = ENROLLMENT_STATUS_RENEWAL_IN_PROG;//[UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
    }
    else if (eState == (enrollmentState)NO_ACTION_REQUIRED)
    {
        pCompanyFooter.text = @"IN COVERAGE";
        pCompanyFooter.textColor = ENROLLMENT_STATUS_ALL_CLIENTS;//[UIColor colorWithRed:0.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    }

    [self addSubview:pCompany];
    [self addSubview:pCompanyFooter];
    
    if (bShowContactButtons)
    {
        for (int btnCount=0;btnCount<4;btnCount++)
        {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag=30+btnCount;

            if (labelSize.height > 40)
                [button setFrame:CGRectMake(10, self.frame.origin.y + self.frame.size.height - (bShowPlanYear ? 68:38), 38, 38)];
            else
                [button setFrame:CGRectMake(10, self.frame.origin.y + self.frame.size.height - (bShowPlanYear ? 78:48), 38, 38)];
            
            [button setBackgroundColor:[UIColor clearColor]];
            UIImage *btnImage;
            switch(btnCount)
            {
                case 0:
                    btnImage = [UIImage imageNamed:@"phone-2.png"];
                    [button addTarget:self action:@selector(phoneEmployer:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 1:
                    btnImage = [UIImage imageNamed:@"message-2.png"];
                    [button addTarget:self action:@selector(smsEmployer:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 2:
                    btnImage = [UIImage imageNamed:@"location-2.png"];
                    [button addTarget:self action:@selector(showDirections:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 3:
                    btnImage = [UIImage imageNamed:@"email-2.png"];
                    [button addTarget:self action:@selector(emailEmployer:) forControlEvents:UIControlEventTouchUpInside];
                    break;
            }
            
            button.contentMode = UIViewContentModeScaleToFill;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            [button setImage:btnImage forState:UIControlStateNormal];
            
            [self addSubview:button];
        }
        
        [self evenlySpaceTheseButtonsInThisView:@[[self viewWithTag:30], [self viewWithTag:31], [self viewWithTag:32], [self viewWithTag:33]] :self];
    }
    
    int jj = pCompanyFooter.frame.origin.y + pCompanyFooter.frame.size.height;
    int bb = [self viewWithTag:30].frame.origin.y;
//    if (bb - jj > 15)
    {
        pCompanyFooter.frame = CGRectMake(pCompanyFooter.frame.origin.x,pCompanyFooter.frame.origin.y+20,pCompanyFooter.frame.size.width,pCompanyFooter.frame.size.height);
        
        pLabelCoverage.frame = CGRectMake(pLabelCoverage.frame.origin.x,pLabelCoverage.frame.origin.y+10,pLabelCoverage.frame.size.width,pLabelCoverage.frame.size.height);
    }

    if (bShowPlanYear)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"Roboto-Bold" size:12], NSFontAttributeName,
                                    [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1], NSForegroundColorAttributeName, nil];
        
        NSArray *itemArray = [NSArray arrayWithObjects: @"ACTIVE YEAR", @"IN RENEWAL", nil];
        planYearControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        planYearControl.frame = CGRectMake(self.frame.size.width/2 - 80, [self viewWithTag:30].frame.origin.y + [self viewWithTag:30].frame.size.height + 10, 160, 30);
        [planYearControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        [planYearControl setTintColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]];
        
        [planYearControl addTarget:self action:@selector(HandleSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
        planYearControl.selectedSegmentIndex = 0;
        
        [self addSubview:planYearControl];
    }
}

-(enrollmentState)getEnrollmentState:(NSDictionary*)eData
{
//    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    if ([[eData valueForKey:@"plan_years"] count] == 0)
        return NO_ACTION_REQUIRED;
    else
    {
        NSArray *pPlan = [[eData valueForKey:@"plan_years"] objectAtIndex:_iCurrentPlanIndex];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
        [f setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        //      NSDate *planYearBegins = [self userVisibleDateTimeForRFC3339Date:[pPlan valueForKey:@"plan_year_begins"] ];
        NSDate *planYearBegins = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"] ];
        
        NSString *todayDateString = [f stringFromDate:[NSDate date]];
        
        NSDate *today = [f dateFromString:todayDateString];
        
        if ([planYearBegins compare:today] == NSOrderedAscending) // && [endEnrollmentDate compare:today] == NSOrderedDescending)
            return NO_ACTION_REQUIRED;
        else
        {
            NSDate *startEnrollmentDate = [f dateFromString:[pPlan valueForKey:@"open_enrollment_begins"]]; //[dateFormatter dateFromString:pCompany.open_enrollment_ends];
            NSDate *endEnrollmentDate = [f dateFromString:[pPlan valueForKey:@"open_enrollment_ends"]]; //[dateFormatter dateFromString:pCompany.open_enrollment_ends];
            
            if ([startEnrollmentDate compare:today] == NSOrderedAscending && [endEnrollmentDate compare:today] == NSOrderedDescending) //If today is greater than open_enrollment_begin AND less than open_enrollment_end
            {
                //if (([pCompany.employeesEnrolled intValue] + [pCompany.employeesWaived intValue]) < [pCompany.planMinimum intValue])
                //                if (([pPlan intValue] + [pCompany.employeesWaived intValue]) < [pCompany.planMinimum intValue])
                //                    return NEEDS_ATTENTION;
                //                else if ( [pCompany.employeesEnrolled intValue] + [pCompany.employeesWaived intValue] >= [pCompany.planMinimum intValue] )
                //                    return OPEN_ENROLLMENT_MET;
            }
            else
            {
                NSLog(@"%@\n",[pPlan valueForKey:@"renewal_in_progress"]);
                
                BOOL bRenewal = FALSE;
                if ([pPlan valueForKey:@"renewal_in_progress"] == (NSString *)[NSNull null])
                    bRenewal = FALSE;
                else
                    bRenewal = [[pPlan valueForKey:@"renewal_in_progress"] boolValue];
                
                if (bRenewal)
                    return RENEWAL_IN_PROGRESS;
                else
                    return NO_ACTION_REQUIRED;
            }
        }
    }
    return NO_ACTION_REQUIRED;
}

- (void)HandleSegmentControlAction:(UISegmentedControl *)segment
{
    [_delegate HandleSegmentControlAction:segment];
}

-(int)layoutEmployeeProfile:(NSDictionary *)eData nameY:(int)nameY
{
    employerDetail = eData;
    UILabel * pLabelCoverage;
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSArray *pPlan = [[eData valueForKey:@"plan_years"] objectAtIndex:_iCurrentPlanIndex];
    
    //   NSDate *planYearBegins = [self userVisibleDateTimeForRFC3339Date:[pPlan valueForKey:@"plan_year_begins"] ];
    
    //   NSDate *planYear = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"]];
    
    
    NSDate *endDate = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"]];                 //[dictionary valueForKey:@"plan_year_begins"]]; //[f dateFromString:type.billing_report_date];

//      NSDate *endDate = [f dateFromString:eData.planYear];//[dictionary valueForKey:@"plan_year_begins"]]; //[f dateFromString:type.billing_report_date];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:364];
        NSDate *targetDate = [gregorian dateByAddingComponents:dateComponents toDate:endDate  options:0];
        
        [f setDateFormat:@"MMM dd, yyyy"];
    
        pLabelCoverage = [[UILabel alloc] initWithFrame:CGRectMake(0, nameY, self.frame.size.width, 45)];
        pLabelCoverage.tag = 975;
        
        pLabelCoverage.numberOfLines = 2;
        pLabelCoverage.backgroundColor = [UIColor clearColor];
        pLabelCoverage.font = [UIFont fontWithName:@"Roboto-Medium" size:15];
        pLabelCoverage.textAlignment = NSTextAlignmentCenter;
        pLabelCoverage.textColor = APPLICATION_DEFAULT_TEXT_COLOR;
        
        pLabelCoverage.hidden = FALSE;
    NSString *lblCoverageYear;// = [NSString stringWithFormat:@"%@ - %@  \u25BE\n", [[f stringFromDate:endDate] uppercaseString], [[f stringFromDate:targetDate] uppercaseString]];

    if ([[eData valueForKey:@"plan_years"] count] > 1)
        lblCoverageYear = [NSString stringWithFormat:@"%@ - %@  \u25BE\n", [[f stringFromDate:endDate] uppercaseString], [[f stringFromDate:targetDate] uppercaseString]];
    else
        lblCoverageYear = [NSString stringWithFormat:@"%@ - %@\n", [[f stringFromDate:endDate] uppercaseString], [[f stringFromDate:targetDate] uppercaseString]];

    
    
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : APPLICATION_DEFAULT_TEXT_COLOR };
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:lblCoverageYear attributes:attrs];
        
        //NSString *temp_a = @"Coverage Year \u25BE";
        NSString *temp_a = @"Coverage Year";
    
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:temp_a attributes:attrs];
        [string1 beginEditing];
        [string1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Medium" size:15.0] range:NSMakeRange(0, string1.length)];
        [string1 endEditing];
        
        [attributedTitle appendAttributedString:string1];
        
        pLabelCoverage.attributedText = attributedTitle;
        
//        [self addSubview:pLabelCoverage];
    
    //       [self addSubview:pLabelCoverage];
    
        UIButton *coverageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-110, nameY, 220, 45)];
    
        [coverageButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
        
        coverageButton.layer.cornerRadius = 10;
        coverageButton.clipsToBounds = YES;
        coverageButton.tag = 99;
        
        coverageButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        coverageButton.titleLabel.numberOfLines = 2;
        coverageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //      coverageButton.layer.borderWidth = 2.0f;
        //      coverageButton.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1].CGColor;
        coverageButton.backgroundColor = UIColorFromRGB(0xE0FFFF); //0xBFEFFF);//  [UIColor clearColor];
        
        coverageButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:15];
        coverageButton.tintColor = [UIColor purpleColor];
        [coverageButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        
        [coverageButton addTarget:self action:@selector(changeCoverageYear:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[eData valueForKey:@"plan_years"] count] > 1)
        [self addSubview:coverageButton];
    else
        [self addSubview:pLabelCoverage];

    
/*
    for (int btnCount=0;btnCount<4;btnCount++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=30+btnCount;
        //    [button setFrame:CGRectMake(10, 95, 38, 38)];
        //[button setFrame:CGRectMake(10, pCompanyFooter.frame.origin.y + pCompanyFooter.frame.size.height + 10, 38, 38)];
        [button setFrame:CGRectMake(10, self.frame.origin.y + self.frame.size.height - 48, 38, 38)];
        
        [button setBackgroundColor:[UIColor clearColor]];
        UIImage *btnImage;
        switch(btnCount)
        {
            case 0:
                btnImage = [UIImage imageNamed:@"phone-2.png"];
                [button addTarget:self action:@selector(phoneEmployer:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                btnImage = [UIImage imageNamed:@"message-2.png"];
                [button addTarget:self action:@selector(smsEmployer:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                btnImage = [UIImage imageNamed:@"location-2.png"];
                [button addTarget:self action:@selector(showDirections:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3:
                btnImage = [UIImage imageNamed:@"email-2.png"];
                [button addTarget:self action:@selector(emailEmployer:) forControlEvents:UIControlEventTouchUpInside];
                break;
        }
        
        button.contentMode = UIViewContentModeScaleToFill;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [button setImage:btnImage forState:UIControlStateNormal];
        
        [self addSubview:button];
    }
    
    [self evenlySpaceTheseButtonsInThisView:@[[self viewWithTag:30], [self viewWithTag:31], [self viewWithTag:32], [self viewWithTag:33]] :self];
*/
    return pLabelCoverage.frame.origin.y + pLabelCoverage.frame.size.height;
    
}

- (void) evenlySpaceTheseButtonsInThisView : (NSArray *) buttonArray : (UIView *) thisView {
    int widthOfAllButtons = 0;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *thisButton = [buttonArray objectAtIndex:i];
        //    [thisButton setCenter:CGPointMake(0, thisView.frame.size.height / 2.0)];
        widthOfAllButtons = widthOfAllButtons + thisButton.frame.size.width;
    }
    
    int spaceBetweenButtons = (thisView.frame.size.width - widthOfAllButtons) / (buttonArray.count + 1);
    
    UIButton *lastButton = nil;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *thisButton = [buttonArray objectAtIndex:i];
        if (lastButton == nil) {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        } else {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons + lastButton.frame.origin.x + lastButton.frame.size.width, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        }
        
        lastButton = thisButton;
    }
}

- (void)phoneEmployer:(id)sender
{
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    sub.messageTitle = employerData.companyName;
//    sub.messageArray = employerData.contact_info;
    sub.messageType = typePopupPhone;
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:sub animated:YES completion: nil];

}

- (void)emailEmployer:(id)sender
{
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    sub.messageTitle = employerData.companyName;
//    sub.messageArray = employerData.contact_info;
    sub.messageType = typePopupEmail;
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:sub animated:YES completion: nil];

}

- (IBAction)smsEmployer:(id)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    sub.messageTitle = employerData.companyName;
//    sub.messageArray = employerData.contact_info;
    sub.messageType = typePopupSMS;
    sub.delegate = self;
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:sub animated:YES completion: nil];

}

- (void)SMSThesePeople:(id)ttype
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObjects:@"12024686571", nil];
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:picker animated:YES completion: nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch(result)
    {
        case MessageComposeResultCancelled:
            // user canceled sms
//            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultSent:
            // user sent sms
            //perhaps put an alert here and dismiss the view on one of the alerts buttons
            break;
        case MessageComposeResultFailed:
            // sms send failed
            //perhaps put an alert here and dismiss the view when the alert is canceled
            break;
        default:
            break;
    }
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC dismissViewControllerAnimated:YES completion:NULL];
}

- (UIViewController *)currentTopViewController {
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

-(void)showDirections:(id)sender
{
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    sub.messageTitle = employerData.companyName;
//    sub.messageArray = employerData.contact_info;
    sub.messageType = typePopupMAP;
    sub.delegate = self;
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:sub animated:YES completion: nil];
}

-(void)MAPTheseDirections:(id)sender
{
    NSArray *ck = [sender objectAtIndex:0];
    NSDictionary *pk = [ck objectAtIndex:0];
    
    //(DB) NEW API CHANGE
    NSString *destinationAddress= [NSString stringWithFormat:@"%@, %@, %@, %@", [pk valueForKey:@"address_1"], [pk valueForKey:@"city"], [pk valueForKey:@"state"], [pk valueForKey:@"zip"]]; //@"130 M Street NE, Washington, DC, 20002";
    //(DB) NEW API CHANGE
    //    NSString *destinationAddress; // = [NSString stringWithFormat:@"%@, %@, %@, %@", type.employer_address_1, type.employer_city, type.employer_state, type.employer_zip]; //@"130 M Street NE, Washington, DC, 20002";
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:destinationAddress
                 completionHandler:^(NSArray *placemarks, NSError *error)
     {
         
         // Convert the CLPlacemark to an MKPlacemark
         // Note: There's no error checking for a failed geocode
         CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
         MKPlacemark *placemark = [[MKPlacemark alloc]
                                   initWithCoordinate:geocodedPlacemark.location.coordinate
                                   addressDictionary:geocodedPlacemark.addressDictionary];
         
         // Create a map item for the geocoded address to pass to Maps app
         MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
         [mapItem setName:geocodedPlacemark.name];
         
         // Set the directions mode to "Driving"
         // Can use MKLaunchOptionsDirectionsModeWalking instead
         NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
         
         // Get the "Current User Location" MKMapItem
         MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
         
         // Pass the current location and destination map items to the Maps app
         // Set the direction mode in the launchOptions dictionary
         [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
         
     }];
}

-(void)changeCoverageYear:(id)sender
{
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Coverage Year" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.delegate = self;
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    actionSheet.tag = 3;
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];

    for (int ii=0;ii<[[employerDetail valueForKey:@"plan_years"] count];ii++)
    {
        [f setDateFormat:@"yyyy-MM-dd"];
        NSDate *planYear = [f dateFromString:[[[employerDetail valueForKey:@"plan_years"] objectAtIndex:ii] valueForKey:@"plan_year_begins"]];

        [f setDateFormat:@"MM/dd/yyyy"];
        
        if (ii==[_delegate getPlanIndex])
        {
            [actionSheet addButtonWithTitle: [NSString stringWithFormat:@"\u2713 %@", [f stringFromDate:planYear]]];
      //      [actionSheet setValue:[UIImage imageNamed:@"check-green.png"] forKey:@"_image"];
     //       [online setValue:[[UIImage imageNamed:@"facebook.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
     //       [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"check-green.png"] forState:UIControlStateNormal];

        }
        else
            [actionSheet addButtonWithTitle: [NSString stringWithFormat:@"%@", [f stringFromDate:planYear]]];
 //       [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"check_green.png"] forState:UIControlStateNormal];
    }
    
//        [employerData.plans objectAtIndex:[employerData.plans count]-1];
    
    [actionSheet showInView:self];
     
}

-(void)drawCoverageYear:(NSInteger)index
{
    UIButton *pBut = [self viewWithTag:99];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *pPlan = [[employerDetail valueForKey:@"plan_years"] objectAtIndex:index];
    
    NSDate *endDate = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"]];                 //[dictionary valueForKey:@"plan_year_begins"]]; //[f dateFromString:type.billing_report_date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:364];
    NSDate *targetDate = [gregorian dateByAddingComponents:dateComponents toDate:endDate  options:0];
    
    [f setDateFormat:@"MMM dd, yyyy"];
    
    NSString *lblCoverageYear = [NSString stringWithFormat:@"%@ - %@  \u25BE\n", [[f stringFromDate:endDate] uppercaseString], [[f stringFromDate:targetDate] uppercaseString]];
    
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : APPLICATION_DEFAULT_TEXT_COLOR };
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:lblCoverageYear attributes:attrs];
    
//    NSString *temp_a = @"Coverage Year \u25BE";
    NSString *temp_a = @"Coverage Year";
    
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:temp_a attributes:attrs];
    [string1 beginEditing];
    [string1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Medium" size:15.0] range:NSMakeRange(0, string1.length)];
    [string1 endEditing];
    
    [attributedTitle appendAttributedString:string1];
    
 //   [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedTitle.length)];
    
    [pBut setAttributedTitle:attributedTitle forState:UIControlStateNormal];
 }

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 3: {
            
            if (buttonIndex>0)
            {
                if ([_delegate changeCoverageYear:buttonIndex-1])
                {
                    _iCurrentPlanIndex = buttonIndex-1;
                    
                    [self drawCoverageYear:_iCurrentPlanIndex];
                }
            }
        }
        default:
            break;
    }
}
@end

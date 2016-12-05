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

- (void)layoutHeaderView:(brokerEmployersData *)eData
{
    [self layoutHeaderView:eData showcoverage:YES showplanyear:NO];
}

- (void)layoutHeaderView:(brokerEmployersData *)eData showcoverage:(BOOL)bShowCoverage showplanyear:(BOOL)bShowPlanYear
{
    employerData = eData;
/*
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 3.0;
*/
    UILabel *pCompany = [[UILabel alloc] init];
    
    pCompany.font = [UIFont fontWithName:@"Roboto-Bold" size:24];
    pCompany.text = employerData.companyName;
    pCompany.textColor = APPLICATION_DEFAULT_TEXT_COLOR;
    pCompany.numberOfLines = 0;
    
    pCompany.textAlignment = NSTextAlignmentCenter;
//    [pCompany sizeToFit];
    pCompany.frame = CGRectMake(10, 0, self.frame.size.width-20, 40);
  
    CGSize labelSize = CGSizeMake(200.0, 20.0);
    UIFont *cellFont = [UIFont fontWithName:@"Roboto-Bold" size:24];
    
    if ([pCompany.text length] > 0)
        labelSize = [pCompany.text sizeWithFont: cellFont constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
    
    if (labelSize.height > 40)
        pCompany.frame = CGRectMake(10, 0, self.frame.size.width-20, labelSize.height - 30);
   
    
    UILabel *pCompanyFooter = [[UILabel alloc] init];
    pCompanyFooter.font = [UIFont fontWithName:@"Roboto-Medium" size:16];
   
    UILabel * pLabelCoverage;
    
    if (bShowCoverage)
    {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
        
        
        NSArray *pPlan = [employerData.plans objectAtIndex:_iCurrentPlanIndex];
        
        //                     NSDate *planYearBegins = [self userVisibleDateTimeForRFC3339Date:[pPlan valueForKey:@"plan_year_begins"] ];
        
 //       NSDate *planYear = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"]];
        
        
        NSDate *endDate = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"]];                 //[dictionary valueForKey:@"plan_year_begins"]]; //[f dateFromString:type.billing_report_date];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:364];
        NSDate *targetDate = [gregorian dateByAddingComponents:dateComponents toDate:endDate  options:0];
        
        [f setDateFormat:@"MMM dd, yyyy"];
        
//        UILabel *pLabelCoverage = [[UILabel alloc] initWithFrame:CGRectMake(0,[self viewWithTag:30].frame.origin.y + [self viewWithTag:30].frame.size.height,self.frame.size.width, 45)];
        pLabelCoverage = [[UILabel alloc] initWithFrame:CGRectMake(0, pCompany.frame.origin.y + pCompany.frame.size.height, self.frame.size.width, 45)];
        pLabelCoverage.tag = 975;
        
        pLabelCoverage.numberOfLines = 2;
        pLabelCoverage.backgroundColor = [UIColor clearColor];
        pLabelCoverage.font = [UIFont fontWithName:@"Roboto-Medium" size:15];
        pLabelCoverage.textAlignment = NSTextAlignmentCenter;
        pLabelCoverage.textColor = APPLICATION_DEFAULT_TEXT_COLOR;
        
        pLabelCoverage.hidden = FALSE;
        NSString *lblCoverageYear;
        
        if ([employerData.plans count] > 1)
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
        
        UIButton *coverageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-110, pCompany.frame.origin.y + pCompany.frame.size.height, 220, 45)];
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

        if ([employerData.plans count] > 1)
            [self addSubview:coverageButton];
        else
            [self addSubview:pLabelCoverage];
        
        pCompanyFooter.frame = CGRectMake(10, pLabelCoverage.frame.origin.y + pLabelCoverage.frame.size.height, self.frame.size.width - 20, 20);

    }
    else
        pCompanyFooter.frame = CGRectMake(10, pCompany.frame.origin.y + pCompany.frame.size.height, self.frame.size.width - 20, pCompanyFooter.frame.size.height);

    
    pCompanyFooter.textAlignment = NSTextAlignmentCenter;
    pCompanyFooter.textColor = UIColorFromRGB(0x555555);
//    pCompany.backgroundColor  = [UIColor greenColor];
    
    if (employerData.status == (enrollmentState)NEEDS_ATTENTION)
    {
        pCompanyFooter.text = NSLocalizedString(@"TITLE_NOTE", @"OPEN ENROLLMENT IN PROGRESS - MINIMUM NOT MET");
        pCompanyFooter.textColor = ENROLLMENT_STATUS_OE_MIN_NOTMET;
        
    }
    else if (employerData.status == (enrollmentState)OPEN_ENROLLMENT_MET)
    {
        pCompanyFooter.text = @"OPEN ENROLLMENT IN PROGRESS";
        pCompanyFooter.textColor = ENROLLMENT_STATUS_OE_MIN_MET;//[UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f]; //[UIColor yellowColor];
        
    }
    else if (employerData.status == (enrollmentState)RENEWAL_IN_PROGRESS)
    {
        pCompanyFooter.text = @"RENEWAL PENDING"; //@"RENEWAL IN PROGRESS";
        pCompanyFooter.textColor = ENROLLMENT_STATUS_RENEWAL_IN_PROG;//[UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
    }
    else if (employerData.status == (enrollmentState)NO_ACTION_REQUIRED)
    {
        pCompanyFooter.text = @"IN COVERAGE";
        pCompanyFooter.textColor = ENROLLMENT_STATUS_ALL_CLIENTS;//[UIColor colorWithRed:0.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    }

    [self addSubview:pCompany];
    [self addSubview:pCompanyFooter];
    
    for (int btnCount=0;btnCount<4;btnCount++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=30+btnCount;
    //    [button setFrame:CGRectMake(10, 95, 38, 38)];
        //[button setFrame:CGRectMake(10, pCompanyFooter.frame.origin.y + pCompanyFooter.frame.size.height + 10, 38, 38)];
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

    int jj = pCompanyFooter.frame.origin.y + pCompanyFooter.frame.size.height;
    int bb = [self viewWithTag:30].frame.origin.y;
    if (bb - jj > 15)
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

- (void)HandleSegmentControlAction:(UISegmentedControl *)segment
{
    [_delegate HandleSegmentControlAction:segment];
}

-(int)layoutEmployeeProfile:(brokerEmployersData *)eData nameY:(int)nameY
{
        employerData = eData;
    UILabel * pLabelCoverage;
    
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
    NSArray *pPlan = [eData.plans objectAtIndex:_iCurrentPlanIndex];
    
    //                     NSDate *planYearBegins = [self userVisibleDateTimeForRFC3339Date:[pPlan valueForKey:@"plan_year_begins"] ];
    
    //       NSDate *planYear = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"]];
    
    
    NSDate *endDate = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"]];                 //[dictionary valueForKey:@"plan_year_begins"]]; //[f dateFromString:type.billing_report_date];

//        NSDate *endDate = [f dateFromString:eData.planYear];//[dictionary valueForKey:@"plan_year_begins"]]; //[f dateFromString:type.billing_report_date];
        
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
        NSString *lblCoverageYear = [NSString stringWithFormat:@"%@ - %@  \u25BE\n", [[f stringFromDate:endDate] uppercaseString], [[f stringFromDate:targetDate] uppercaseString]];
        
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
        
        [self addSubview:coverageButton];
    
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
    sub.messageTitle = employerData.companyName;
    sub.messageArray = employerData.contact_info;
    sub.messageType = typePopupPhone;
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:sub animated:YES completion: nil];

}

- (void)emailEmployer:(id)sender
{
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = employerData.companyName;
    sub.messageArray = employerData.contact_info;
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
    sub.messageTitle = employerData.companyName;
    sub.messageArray = employerData.contact_info;
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
    sub.messageTitle = employerData.companyName;
    sub.messageArray = employerData.contact_info;
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

    for (int ii=0;ii<[employerData.plans count];ii++)
    {
        [f setDateFormat:@"yyyy-MM-dd"];
        NSDate *planYear = [f dateFromString:[[employerData.plans objectAtIndex:ii] valueForKey:@"plan_year_begins"]];

        [f setDateFormat:@"MM/dd/yyyy"];
        
        if (ii==[_delegate getPlanIndex])
            [actionSheet addButtonWithTitle: [NSString stringWithFormat:@"\u2705 %@", [f stringFromDate:planYear]]];
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
    
    NSArray *pPlan = [employerData.plans objectAtIndex:index];
    
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
                _iCurrentPlanIndex = buttonIndex-1;
                
                [self drawCoverageYear:_iCurrentPlanIndex];

                [_delegate changeCoverageYear:buttonIndex-1];
            }
            
            /*
            switch (buttonIndex) {
             
                case 0:
 //                   [self FBShare];
                    break;
                case 1:
//                    [self TwitterShare];
                    break;
                case 2:
 //                   [self emailContent];
                    break;
                case 3:
 //                   [self saveContent];
                    break;
                case 4:
 //                   [self rateAppYes];
                    break;
                default:
                    break;
            }
            break;
             */
        }
        default:
            break;
    }
}
/*
-(void)datePickerDoneClicked
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *tmp=[outputFormatter stringFromDate:datePicker.date];
    if (isSelectDate==TRUE) {
        [btnfrom setTitle:tmp forState:UIControlStateNormal];
    }
    else{
        [btnTo setTitle:tmp forState:UIControlStateNormal];
        
    }
    [outputFormatter release];
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
*/
/*
-(void)datePickerCancelClicked
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark -Button Click Event

-(IBAction)btnfromPress:(id)sender
{
    isSelectDate=TRUE;
//    [self openactionsheetWithDatePicker];
}

-(IBAction)btnToPress:(id)sender
{
    isSelectDate =FALSE;
//    [self openactionsheetWithDatePicker];
}
 */
@end

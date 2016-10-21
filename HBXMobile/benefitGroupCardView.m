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
    if (currrentCard == cardCount)
        [_delegate scrolltoNextPage:0];
    else
        [_delegate scrolltoNextPage:currrentCard];
}

-(void)layoutView:(int)cc totalPages:(NSInteger)totalCards
{
    NSLog(@"W:%f     H:%f", self.bounds.size.width, self.bounds.size.height);
//    CGFloat scaleX = self.frame.size.width/394;
//    CGFloat scaleY = self.frame.size.height/448;
//    CGFloat scale = MIN(scaleX, scaleY);
    
    if (!expandedSections)
        expandedSections = [[NSMutableIndexSet alloc] init];

    [expandedSections addIndex:0];
    
    _planDetails = [[NSMutableArray alloc] init];
    [_planDetails addObject:[NSArray arrayWithObjects:@"ELIGIBILITY", [_po valueForKey:@"eligibility_rule"], nil]];
    [_planDetails addObject:[NSArray arrayWithObjects:@"CONTRIBUTION LEVELS", @"0", nil]];
    [_planDetails addObject:[NSArray arrayWithObjects:@"REFERENCE PLAN", [[_po valueForKey:@"health"] valueForKey:@"reference_plan_name"], nil]];


    _planDentalDetails = [[NSMutableArray alloc] init];
    
    if ([_po valueForKey:@"dental"] != [NSNull null])
    {
        [_planDentalDetails addObject:[NSArray arrayWithObjects:@"ELIGIBILITY", [_po valueForKey:@"eligibility_rule"], nil]];
        [_planDentalDetails addObject:[NSArray arrayWithObjects:@"CONTRIBUTION LEVELS", @"0", nil]];
        [_planDentalDetails addObject:[NSArray arrayWithObjects:@"ELECTED DENTAL PLANS", [NSString stringWithFormat:@"\t\u2022 %@", @"BlueDental Preferred"], nil]];
        [_planDentalDetails addObject:[NSArray arrayWithObjects:@"EPLIST", [NSString stringWithFormat:@"\t\u2022 %@", @"BlueDental Traditional"], nil]];
        [_planDentalDetails addObject:[NSArray arrayWithObjects:@"EPLIST", [NSString stringWithFormat:@"\t\u2022 %@", @"Delta Dental PPO Basic Plan for Families for Small Businesses"], nil]];
        [_planDentalDetails addObject:[NSArray arrayWithObjects:@"REFERENCE PLAN", [[_po valueForKey:@"dental"] valueForKey:@"reference_plan_name"], nil]];
    }
    currrentCard = cc;
    cardCount = totalCards;
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
/*
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Roboto-Bold" size:12], NSFontAttributeName,
                                [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1], NSForegroundColorAttributeName, nil];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Active Year", @"In Renewal", nil];
     UISegmentedControl *planYearControl = [[UISegmentedControl alloc] initWithItems:itemArray];
     planYearControl.frame = CGRectMake(self.frame.size.width - 150, 5, 140, 25);
    [planYearControl setTitleTextAttributes:attributes forState:UIControlStateNormal];

    [planYearControl setTintColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]];
    
     [planYearControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
     planYearControl.selectedSegmentIndex = 0;
    
    if (cc == 1)
     [self addSubview:planYearControl];
 */   
    
    UILabel *lblBenefitGroupName = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 150, 20)];
    lblBenefitGroupName.text = [_po valueForKey:@"benefit_group_name"];
    lblBenefitGroupName.font = [UIFont fontWithName:@"Roboto-Regular" size:20.0f];
    lblBenefitGroupName.textColor = UIColorFromRGB(0x555555);
    [lblBenefitGroupName sizeToFit];
    [self addSubview:lblBenefitGroupName];
    
    
    planTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width, self.frame.size.height - 65) style:UITableViewStyleGrouped];
    planTable.dataSource = self;
    planTable.delegate = self;
    planTable.rowHeight = 44.0f;
    planTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    planTable.layer.cornerRadius = 10;
    
    [planTable setBackgroundView:nil];
    [planTable setBackgroundColor:[UIColor whiteColor]];  //[UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:1.0]];
    [self addSubview:planTable];


//    [self layer].anchorPoint = CGPointMake(0.0f, 0.0f);
//    self.transform = CGAffineTransformMakeScale(2, 2);
/*
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
*/
 /*
    lblContributionEmployee.transform = CGAffineTransformScale(CGAffineTransformIdentity, fScale, fScale);
    lblContributionSpouse.transform = CGAffineTransformScale(CGAffineTransformIdentity, fScale, fScale);
    lblContributionPartner.transform = CGAffineTransformScale(CGAffineTransformIdentity, fScale, fScale);
    lblContributionChild.transform = CGAffineTransformScale(CGAffineTransformIdentity, fScale, fScale);
*/
 //   [self evenlySpaceTheseButtonsInThisView:@[lblContributionEmployee, lblContributionSpouse, lblContributionPartner, lblContributionChild] :self];

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_planDentalDetails count] > 0)
        return 2;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([expandedSections containsIndex:section])
    {
        if (section == 1)
            return 6;
        
        return 3;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 && (indexPath.section == 0 || indexPath.section == 1))
        return 118;
    
    if (indexPath.section == 1 && (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4))
        return 35;

    if (indexPath.section == 1 && indexPath.row == 5 )
        return 55;

    CGSize labelSize = CGSizeMake(200.0, 20.0);
    NSString *cellText;
    if (indexPath.section == 0)
        cellText = [[_planDetails objectAtIndex:indexPath.row] objectAtIndex:1];
    else
        cellText = [[_planDentalDetails objectAtIndex:indexPath.row] objectAtIndex:1];
    
    UIFont *cellFont = [UIFont fontWithName:@"Roboto-Regular" size:14];
    
    if ([cellText length] > 0)
        labelSize = [cellText sizeWithFont: cellFont constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
    
    if (labelSize.height + 10 < 44)
        return 44;
    
    return (labelSize.height + 20);
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
    
    CGRect CellFrame = CGRectMake(0, 0, self.frame.size.width, 105);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    UIView *conrtibutionView = [[UIView alloc] initWithFrame:CellFrame];
    conrtibutionView.tag = 120;
    conrtibutionView.hidden = YES;
    
    UILabel *lblContribution = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    lblContribution.text = @"CONTRIBUTION LEVELS";
    lblContribution.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblContribution.textColor = UIColorFromRGB(0x555555);
    lblContribution.textAlignment = NSTextAlignmentLeft;
    [lblContribution sizeToFit];
    [conrtibutionView addSubview:lblContribution];

    
    UILabel *lblContributionEmployee = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 100, 20)];
    lblContributionEmployee.tag = 121;
    lblContributionEmployee.numberOfLines = 2;
    lblContributionEmployee.textAlignment = NSTextAlignmentCenter;
    [lblContributionEmployee sizeToFit];
    [conrtibutionView addSubview:lblContributionEmployee];
    
    
    UILabel *lblContributionSpouse = [[UILabel alloc] initWithFrame:CGRectMake(100,30,100, 20)];
    lblContributionSpouse.tag = 122;
    lblContributionSpouse.numberOfLines = 2;
    lblContributionSpouse.textAlignment = NSTextAlignmentCenter;
    [lblContributionSpouse sizeToFit];
    [conrtibutionView addSubview:lblContributionSpouse];
    
    
    UILabel *lblContributionPartner = [[UILabel alloc] initWithFrame:CGRectMake(200,30,100, 20)];
    lblContributionPartner.tag = 123;
    lblContributionPartner.numberOfLines = 3;
    lblContributionPartner.textAlignment = NSTextAlignmentCenter;
    [lblContributionPartner sizeToFit];
    [conrtibutionView addSubview:lblContributionPartner];
    
    
    UILabel *lblContributionChild = [[UILabel alloc] initWithFrame:CGRectMake(300, 30, 100, 20)];
    lblContributionChild.tag = 124;
    lblContributionChild.numberOfLines = 2;
    lblContributionChild.textAlignment = NSTextAlignmentCenter;
    [lblContributionChild sizeToFit];
    [conrtibutionView addSubview:lblContributionChild];
    
//    [self evenlySpaceTheseButtonsInThisView:@[lblContributionEmployee, lblContributionSpouse, lblContributionPartner, lblContributionChild] :conrtibutionView];
    
    [cell.contentView addSubview:conrtibutionView];
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // The view for the header
//    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.size.width/2 - 75, 0, 150, 34)];
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 34)];
    
    // Set a custom background color and a border
    headerView.backgroundColor = UIColorFromRGB(0x00a99e);//[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    headerView.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;//[UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    headerView.tag = section;
    
    // Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 0, tableView.frame.size.width - 5, 34);
//    headerLabel.frame = CGRectMake(tableView.frame.size.width/2-75, 0, 150, 34);
    headerLabel.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16.0];
    if (section == 0)
        headerLabel.text = @"Health";
    else
        headerLabel.text = @"Dental";

    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    // Add the label to the header view
    [headerView addSubview:headerLabel];
    
    if ([expandedSections containsIndex:section])
    {
        UIImageView *imgVew = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-40, 2, 28, 28)];
        imgVew.backgroundColor = [UIColor clearColor];
        imgVew.image = [UIImage imageNamed:@"uparrowWHT.png"];
        imgVew.contentMode = UIViewContentModeScaleAspectFit;
        // Add the image to the header view
        [headerView addSubview:imgVew];
    }
    else
    {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-40, 2, 28, 28)];
        button.layer.cornerRadius = 14;
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor whiteColor].CGColor;//  [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1].CGColor;
        button.clipsToBounds = YES;
        button.tag = section;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:24.0];
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:[NSString stringWithFormat:@"%@", @"+"] forState:UIControlStateNormal];
        
        [headerView addSubview:button];
    }

    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [headerView addGestureRecognizer:recognizer];

    return headerView;
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    UIView *pHeaderView = (UIView*)sender.view;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [planTable beginUpdates];
    [planTable reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:planTable didSelectHeader:indexPath];
    
    [planTable endUpdates];
    
    if ([expandedSections containsIndex:pHeaderView.tag])
        [planTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)handleButtonTap:(id)sender {
    UIView *pHeaderView = (UIView*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [planTable beginUpdates];
    [planTable reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:planTable didSelectHeader:indexPath];
    
    [planTable endUpdates];
    
    if ([expandedSections containsIndex:pHeaderView.tag])
        [planTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectHeader:(NSIndexPath *)indexPath
{
    if (!indexPath.row)
    {
        // only first row toggles exapand/collapse
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSInteger section = indexPath.section;
        BOOL currentlyExpanded = [expandedSections containsIndex:section];
        NSInteger rows;
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        
        if (currentlyExpanded)
        {
            rows = [self tableView:tableView numberOfRowsInSection:section];
            [expandedSections removeIndex:section];
        }
        else
        {
            [expandedSections addIndex:section];
            if ((rows = [self tableView:tableView numberOfRowsInSection:section]) == 0)
                [expandedSections removeIndex:section];
        }
        
        for (int i=0; i<rows; i++) ///(DB) modified this from i=1 to i=0 to account for viewHeader being clicked and not first row.
        {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                           inSection:section];
            [tmpArray addObject:tmpIndexPath];
        }
        
        if (currentlyExpanded)
        {
            [tableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationBottom];
            
            //              cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
        }
        else
        {
            [tableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
            //            cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell = [self getCellContentView:CellIdentifier];
  }
    
    cell.textLabel.textColor = UIColorFromRGB(0x555555);
    cell.detailTextLabel.textColor = UIColorFromRGB(0x555555);
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    
//    cell.textLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]; //[UIColor redColor];
//    cell.detailTextLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    
    UIView *lblContributionView = (UIView *)[cell viewWithTag:120];
    lblContributionView.hidden = YES;
    
    if (indexPath.section == 0)
    {
//        NSString *txt = [[_planDetails objectAtIndex:indexPath.row] objectAtIndex:1];

        if (indexPath.section == 0 && indexPath.row == 1)
        {
            lblContributionView.hidden = NO;
            UILabel *lblContributionEmployee = (UILabel *)[cell viewWithTag:121];
            UILabel *lblContributionSpouse = (UILabel *)[cell viewWithTag:122];
            UILabel *lblContributionPartner = (UILabel *)[cell viewWithTag:123];
            UILabel *lblContributionChild = (UILabel *)[cell viewWithTag:124];
            
            NSString *empCont =  [[[[_po valueForKey:@"health"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"employee"] stringValue];
            lblContributionEmployee.attributedText = [self setAttributedLabel:empCont text2:@"EMPLOYEE" color:UIColorFromRGB(0x00a3e2)];
            
            [lblContributionEmployee sizeToFit];
            
            NSString *spouseCont =  [[[[_po valueForKey:@"health"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"spouse"] stringValue];
            lblContributionSpouse.attributedText = [self setAttributedLabel:spouseCont text2:@"SPOUSE" color:UIColorFromRGB(0x00a99e)];

            [lblContributionSpouse sizeToFit];
            
            NSString *partnerCont =  [[[[_po valueForKey:@"health"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"domestic_partner"] stringValue];
            lblContributionPartner.attributedText = [self setAttributedLabel:partnerCont text2:@"DOMESTIC\nPARTNER" color:UIColorFromRGB(0x625ba8)];

            [lblContributionPartner sizeToFit];
            
            NSString *childCont =  [[[[_po valueForKey:@"health"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"child"] stringValue];
            lblContributionChild.attributedText = [self setAttributedLabel:childCont text2:@"CHILD <26" color:UIColorFromRGB(0xf06eaa)];
            
            [lblContributionChild sizeToFit];

            [self evenlySpaceTheseButtonsInThisView:@[lblContributionEmployee, lblContributionSpouse, lblContributionPartner, lblContributionChild] :lblContributionView];
        }
        else
        {
            cell.textLabel.text = [[_planDetails objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.detailTextLabel.text = [[_planDetails objectAtIndex:indexPath.row] objectAtIndex:1];
        }
    }
    else
    {
        if (indexPath.section == 1 && indexPath.row == 1)
        {
            lblContributionView.hidden = NO;
            UILabel *lblContributionEmployee = (UILabel *)[cell viewWithTag:121];
            UILabel *lblContributionSpouse = (UILabel *)[cell viewWithTag:122];
            UILabel *lblContributionPartner = (UILabel *)[cell viewWithTag:123];
            UILabel *lblContributionChild = (UILabel *)[cell viewWithTag:124];
            
            NSString *empCont =  [[[[_po valueForKey:@"dental"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"employee"] stringValue];
            lblContributionEmployee.attributedText = [self setAttributedLabel:empCont text2:@"EMPLOYEE" color:UIColorFromRGB(0x00a3e2)];
            
            [lblContributionEmployee sizeToFit];
            
            NSString *spouseCont =  [[[[_po valueForKey:@"dental"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"spouse"] stringValue];
            lblContributionSpouse.attributedText = [self setAttributedLabel:spouseCont text2:@"SPOUSE" color:UIColorFromRGB(0x00a99e)];
            
            [lblContributionSpouse sizeToFit];
            
            NSString *partnerCont =  [[[[_po valueForKey:@"dental"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"domestic_partner"] stringValue];
            lblContributionPartner.attributedText = [self setAttributedLabel:partnerCont text2:@"DOMESTIC\nPARTNER" color:UIColorFromRGB(0x625ba8)];
            
            [lblContributionPartner sizeToFit];
            
            NSString *childCont =  [[[[_po valueForKey:@"dental"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"child"] stringValue];
            lblContributionChild.attributedText = [self setAttributedLabel:childCont text2:@"CHILD <26" color:UIColorFromRGB(0xf06eaa)];
            
            [lblContributionChild sizeToFit];
            
            [self evenlySpaceTheseButtonsInThisView:@[lblContributionEmployee, lblContributionSpouse, lblContributionPartner, lblContributionChild] :lblContributionView];
        }
        else
        {
            if (![[[_planDentalDetails objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:@"EPLIST"])
                cell.textLabel.text = [[_planDentalDetails objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.detailTextLabel.text = [[_planDentalDetails objectAtIndex:indexPath.row] objectAtIndex:1];
        }
    }
    return cell;
}

-(NSAttributedString*)setAttributedLabel:(NSString*)labelText1 text2:(NSString*)labelText2 color:(UIColor*)color
{
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color };
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:labelText1 attributes:attrs];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    [attributedTitle beginEditing];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:(screenSize.width <= 320) ? 24.0 : 32.0] range:NSMakeRange(0, attributedTitle.length)];
    [attributedTitle endEditing];
    
    NSMutableAttributedString *attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:@"%\n" attributes:attrs];
    
    [attributedTitle1 beginEditing];
    [attributedTitle1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:(screenSize.width <= 320) ? 16.0 : 18.0] range:NSMakeRange(0, attributedTitle1.length)];
    [attributedTitle1 endEditing];
    
    NSMutableAttributedString *attributedTitle2 = [[NSMutableAttributedString alloc] initWithString:labelText2 attributes:attrs];
    
    [attributedTitle2 beginEditing];
    [attributedTitle2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:(screenSize.width <= 320) ? 14.0 : 16.0] range:NSMakeRange(0, attributedTitle2.length)];
    [attributedTitle2 endEditing];
    
    [attributedTitle appendAttributedString:attributedTitle1];
    [attributedTitle appendAttributedString:attributedTitle2];

    return attributedTitle;
}
@end

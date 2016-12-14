//
//  popupMessageBox.m
//  HBXMobile
//
//  Created by David Boyd on 7/13/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "popupMessageBox.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@interface popupMessageBox ()

@end

@implementation popupMessageBox

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    UIImageView *pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,34,54)];
    pImageView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];   //[UIColor whiteColor];

    pImageView.contentMode = UIViewContentModeCenter;
    
    switch (_messageType)
    {
        case typePopupEmail:
            [self processEmailFromArray];
            pImageView.image = [UIImage imageNamed:@"email.png"]; //@"emailWithCirclelightBlue.png"];
            break;
        case typePopupPhone:
            [self processPhoneFromArray];
            pImageView.image = [UIImage imageNamed:@"phone.png"]; //@"phoneCirclelightBlue.png"];
            break;
        case typePopupSMS:
            [self processPhoneFromArray];
            pImageView.image = [UIImage imageNamed:@"message.png"];//@"chatWithCircleLightBlue.png"];
            break;
        case typePopupMAP:
            [self processMapFromArray];
            pImageView.image = [UIImage imageNamed:@"location.png"]; //@"markerWithCircleLightBlue.png"];
            break;
        case typePopupPlanYears:
            [self processPlanYearsFromArray];
            pImageView.image = nil;//[UIImage imageNamed:@"location.png"];
            break;
    }
    
    UIView* transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    if (_messageType == typePopupPlanYears)
//        transparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
//    else
        transparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    
    [self.view addSubview:transparentView];
    
    if (_messageType == typePopupPlanYears)
        messageTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-175, self.view.frame.size.height - 350, 350, 260) style:UITableViewStyleGrouped];
    else
        messageTable = [[UITableView alloc] initWithFrame:CGRectMake(30, 100, 300, 280) style:UITableViewStyleGrouped];
    
    messageTable.dataSource = self;
    messageTable.delegate = self;
    messageTable.rowHeight = 44.0f;
    messageTable.layer.cornerRadius = 10;
    
    if (_messageType != typePopupPlanYears)
        messageTable.center = transparentView.center;
//    messageTable.frame = CGRectMake(messageTable.frame.origin.x, messageTable.frame.origin.y-55, messageTable.frame.size.width, messageTable.frame.size.height);
    
    [messageTable setBackgroundView:nil];
    [messageTable setBackgroundColor:[UIColor whiteColor]];  //[UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:1.0]];
    [self.view addSubview:messageTable];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(messageTable.frame.origin.x, messageTable.frame.origin.y + messageTable.frame.size.height + 2, messageTable.frame.size.width, 54)];
    if (_messageType == typePopupPlanYears)
    {
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitleColor:APPLICATION_DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
    }
    else
        cancelButton.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    
    cancelButton.layer.cornerRadius = 10;
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Roboto-BOLD" size:18];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    CGFloat headerHeight = 54.0f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, headerHeight)];
    UIView *headerContentView = [[UIView alloc] initWithFrame:headerView.bounds];
    
    if (_messageType == typePopupPlanYears)
        headerContentView.backgroundColor = [UIColor whiteColor];
    else
        headerContentView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    
    headerContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, messageTable.frame.size.width - 35 -35, headerHeight)];
    label.backgroundColor = [UIColor clearColor];

    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    if (_messageType == typePopupPlanYears)
    {
        label.font = [UIFont fontWithName:@"Roboto-BOLD" size:18];
        label.textColor = APPLICATION_DEFAULT_TEXT_COLOR;
        
        UILabel *sublabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y + label.frame.size.height, messageTable.frame.size.width, 20)];
        sublabel.backgroundColor = [UIColor clearColor];
        sublabel.font = [UIFont fontWithName:@"Roboto-BOLD" size:16];
        sublabel.lineBreakMode = NSLineBreakByWordWrapping;
        sublabel.numberOfLines = 1;
        sublabel.textAlignment = NSTextAlignmentCenter;
        sublabel.text = @"Choose Plan Year";
        sublabel.textColor = APPLICATION_DEFAULT_TEXT_COLOR;
        [headerContentView addSubview:sublabel];
    }
    else
    {
        label.font = [UIFont fontWithName:@"Roboto-BOLD" size:15];
        label.textColor = [UIColor whiteColor];
    }
    
    label.text = _messageTitle;
    [headerContentView addSubview:label];
    
    if (_messageType != typePopupPlanYears)
        [headerContentView addSubview:pImageView];
    
    [headerView addSubview:headerContentView];
    messageTable.tableHeaderView = headerView;
    
/*
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blueColor].CGColor; // If you dont give this, shadow will not come, dont know why
    sublayer.shadowOffset = CGSizeMake(0, 2);
    sublayer.shadowRadius = 3.0;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 1.0;
    sublayer.cornerRadius = 10.0;
    messageTable.clipsToBounds = NO;
    messageTable.layer.masksToBounds = NO;
    
    sublayer.frame = CGRectMake(messageTable.frame.origin.x, messageTable.frame.origin.y, messageTable.frame.size.width, messageTable.frame.size.height);
    [self.view.layer addSublayer:sublayer];
    [self.view.layer addSublayer:messageTable.layer];
    
    cancelButton.layer.shadowColor = [UIColor blackColor].CGColor;
    cancelButton.layer.shadowOpacity = 1.0;
    cancelButton.layer.shadowRadius = 3.0;
    cancelButton.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
 */
}

-(void)viewWillAppear:(BOOL)animated
{
    CATransition *animation = [CATransition animation];
    
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    
    [animation setDuration:0.30];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:
      kCAMediaTimingFunctionEaseInEaseOut]];
    
    
    [self.view.layer addAnimation:animation forKey:kCATransition];
}

-(void)cancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processPlanYearsFromArray
{
//    NSMutableArray *rootArray = [[NSMutableArray alloc] init];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];

    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    
    for (int ii=0;ii<[_messageArray count];ii++)
    {
        [f setDateFormat:@"yyyy-MM-dd"];
        NSDate *planYear = [f dateFromString:[[_messageArray objectAtIndex:ii] valueForKey:@"plan_year_begins"]];
        
        [f setDateFormat:@"MM/dd/yyyy"];
        
        NSMutableDictionary *pDict = [[NSMutableDictionary alloc] init];
        [pDict setObject:[f stringFromDate:planYear] forKey:@"planYear"];
        [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"state"] forKey:@"state"];
        [pArray addObject:pDict];
    }
    
    _messageArray = pArray;
}

-(void)processPhoneFromArray
{
    NSMutableArray *rootArray = [[NSMutableArray alloc] init];

    for (int ii=0;ii<[_messageArray count];ii++)
    {
        NSMutableArray *pArray = [[NSMutableArray alloc] init];
        if (_messageType == typePopupPhone)
        {
            if ([[[_messageArray objectAtIndex:ii] valueForKey:@"phone"] length] > 0)
            {
                NSMutableDictionary *pDict = [[NSMutableDictionary alloc] init];
                [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"phone"] forKey:@"phone"];
                [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"last"] forKey:@"last"];
                [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"first"] forKey:@"first"];
                [pDict setObject:@"office" forKey:@"type"];
                [pArray addObject:pDict];

            }
        }
        if ([[[_messageArray objectAtIndex:ii] valueForKey:@"mobile"] length] > 0)
        {
            NSMutableDictionary *pDict = [[NSMutableDictionary alloc] init];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"mobile"] forKey:@"phone"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"last"] forKey:@"last"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"first"] forKey:@"first"];
            [pDict setObject:@"mobile" forKey:@"type"];
            [pArray addObject:pDict];
        }
        if ([pArray count] > 0)
            [rootArray addObject:pArray];
    }
    
    _messageArray = rootArray;
}

-(void)processEmailFromArray
{
    NSMutableArray *rootArray = [[NSMutableArray alloc] init];
    
    for (int ii=0;ii<[_messageArray count];ii++)
    {
        NSMutableArray *pArray = [[NSMutableArray alloc] init];
        if ([[[_messageArray objectAtIndex:ii] valueForKey:@"emails"] count] > 0)
        {
            NSMutableDictionary *pDict = [[NSMutableDictionary alloc] init];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"phone"] forKey:@"phone"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"last"] forKey:@"last"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"first"] forKey:@"first"];
            [pDict setObject:@"office" forKey:@"type"];
            
            BOOL bValidEmail = FALSE;
            NSArray *emails = [[_messageArray objectAtIndex:ii] valueForKey:@"emails"];
            for (long yy=0;yy<[emails count];yy++)
            {
                NSArray *pp =[emails objectAtIndex:yy];
                if (![pp isKindOfClass:[NSNull class]])
                {
                    if ([[emails objectAtIndex:yy] length] > 0)
                    {
                        [pDict setObject:[emails objectAtIndex:yy] forKey:@"email"];
                        bValidEmail = TRUE;
                    }
                    else
                        bValidEmail = FALSE;
                }
            }
            if (bValidEmail)
                [pArray addObject:pDict];
            
        }

        if ([pArray count] > 0)
            [rootArray addObject:pArray];
    }
    
    _messageArray = rootArray;
}

-(void)processMapFromArray
{
    NSMutableArray *rootArray = [[NSMutableArray alloc] init];
    
    for (int ii=0;ii<[_messageArray count];ii++)
    {
        NSMutableArray *pArray = [[NSMutableArray alloc] init];
        if ([[[_messageArray objectAtIndex:ii] valueForKey:@"address_1"] length] > 0)
        {
            NSMutableDictionary *pDict = [[NSMutableDictionary alloc] init];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"phone"] forKey:@"phone"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"last"] forKey:@"last"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"first"] forKey:@"first"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"address_1"] forKey:@"address_1"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"city"] forKey:@"city"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"state"] forKey:@"state"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"zip"] forKey:@"zip"];
            [pDict setObject:@"office" forKey:@"type"];
            [pArray addObject:pDict];
        }
        
        if ([pArray count] > 0)
            [rootArray addObject:pArray];
    }
    
    _messageArray = rootArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_messageType == typePopupPlanYears)
        return 1;
    
    if ([_messageArray count] == 0)
    {
        _messageType = typePopupEmpty;
        return 1;
    }
    
    return [_messageArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_messageType == typePopupPlanYears)
        return [_messageArray count];
    
    if ([_messageArray count] == 0)
    {
        _messageType = typePopupEmpty;
        return 1;
    }
    
    return [[_messageArray objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == [_messageArray count])
        return 5;
    
    return 34.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_messageType == typePopupPlanYears)
        return nil;
    
    // The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    
    // Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    headerView.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;//[UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    headerView.tag = section;
    
    // Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 0, tableView.frame.size.width - 5, 34);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor darkGrayColor];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16.0];
    if (_messageType == typePopupEmpty)
        headerLabel.text = @"No data available";
    else
        headerLabel.text = [NSString stringWithFormat:@"%@, %@", [[[_messageArray objectAtIndex:section] objectAtIndex:0] valueForKey:@"last"], [[[_messageArray objectAtIndex:section] objectAtIndex:0] valueForKey:@"first"]];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // Add the label to the header view
    [headerView addSubview:headerLabel];
    
    return headerView;
}

/* /////Kinda Cool effect
  //////
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.5 animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        if (_messageType == typePopupMAP)
        {
            UILabel* detailLabel_1 = [[UILabel alloc] init];
            detailLabel_1.frame = CGRectMake(10, 17, tableView.frame.size.width, 10);
            detailLabel_1.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
            detailLabel_1.tag = 33;
            detailLabel_1.hidden = FALSE;
            [cell.contentView addSubview:detailLabel_1];
        }
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    
    cell.textLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]; //[UIColor redColor];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (_messageType)
    {
        case typePopupEmail:
            cell.textLabel.text = [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"type"];
            cell.detailTextLabel.text = [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"email"];
            break;
        case typePopupPhone:
        case typePopupSMS:
            cell.textLabel.text = [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"type"];
            cell.detailTextLabel.text = [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"phone"];
            break;
        case typePopupMAP:
            {
                UILabel *pDetail_1 = [cell viewWithTag:33];
                NSString *sDetail_1 = [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"address_1"];
                NSString *sDetail_2 = [NSString stringWithFormat:@"%@, %@  %@", [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"city"], [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"state"],[[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"zip"]];
 
                pDetail_1.text = [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"type"];
                pDetail_1.textColor = cell.textLabel.textColor;
                
                cell.detailTextLabel.numberOfLines = 2;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", sDetail_1, sDetail_2];
            }
            break;
        case typePopupPlanYears:
        {
            cell.textLabel.text = [[_messageArray objectAtIndex:indexPath.row] valueForKey:@"planYear"];
            cell.detailTextLabel.text = [[_messageArray objectAtIndex:indexPath.row] valueForKey:@"state"];
            if (_customCode == indexPath.row)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case typePopupEmpty:
 //           cell.textLabel.text = @"No data available";
            //cell.detailTextLabel.text = [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"phone"];
            break;
            
    }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_messageType)
    {
        case typePopupEmail:
            {
                NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=Hello from HBX!", [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"email"]];
                NSString *body = @"&body=It is sunny in DC!";
                NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
                
                email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
            }
            break;
        case typePopupPhone:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"phone"]]]];
            break;
        case typePopupSMS:
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"Dismiss completed");
                    [_delegate SMSThesePeople:_messageArray];
                }];
            }
            break;
        case typePopupMAP:
        {
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"Dismiss completed");
                [_delegate MAPTheseDirections:_messageArray];
            }];
        }
            break;
        case typePopupPlanYears:
        {
            [_delegate setCoverageYear:indexPath.row];
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"Dismiss completed");

            }];
        }
            break;

    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

//
//  popupMessageBox.m
//  HBXMobile
//
//  Created by David Boyd on 7/13/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "popupMessageBox.h"
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
    
    [self processPhoneFromArray];
    
    UIView* transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    [self.view addSubview:transparentView];
    
    messageTable = [[UITableView alloc] initWithFrame:CGRectMake(30, 100, 300, 280) style:UITableViewStyleGrouped];
    messageTable.dataSource = self;
    messageTable.delegate = self;
    messageTable.rowHeight = 44.0f;
    messageTable.layer.cornerRadius = 10;
    
    messageTable.center = transparentView.center;
    messageTable.frame = CGRectMake(messageTable.frame.origin.x, messageTable.frame.origin.y-55, messageTable.frame.size.width, messageTable.frame.size.height);
    
    [messageTable setBackgroundView:nil];
    [messageTable setBackgroundColor:[UIColor whiteColor]];  //[UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:1.0]];
    [self.view addSubview:messageTable];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(messageTable.frame.origin.x, messageTable.frame.origin.y + messageTable.frame.size.height + 2, messageTable.frame.size.width, 40)];
    cancelButton.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    cancelButton.layer.cornerRadius = 10;
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Roboto-BOLD" size:16];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    CGFloat headerHeight = 74.0f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, headerHeight)];
    UIView *headerContentView = [[UIView alloc] initWithFrame:headerView.bounds];
    headerContentView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    headerContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, messageTable.frame.size.width - 5, headerHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Roboto-BOLD" size:16];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];//[UIColor colorWithRed:79.0f/255.0f green:148.0f/255.0f blue:205.0f/255.0f alpha:1.0f];//[UIColor darkGrayColor];
    label.text = _messageTitle;
    [headerContentView addSubview:label];
    [headerView addSubview:headerContentView];
    messageTable.tableHeaderView = headerView;
}

-(void)cancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processPhoneFromArray
{
    NSMutableArray *rootArray = [[NSMutableArray alloc] init];

    for (int ii=0;ii<[_messageArray count];ii++)
    {
        NSMutableArray *pArray = [[NSMutableArray alloc] init];
        if ([[[_messageArray objectAtIndex:ii] valueForKey:@"phone"] length] > 0)
        {
            NSMutableDictionary *pDict = [[NSMutableDictionary alloc] init];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"phone"] forKey:@"phone"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"last"] forKey:@"last"];
            [pDict setObject:[[_messageArray objectAtIndex:ii] valueForKey:@"first"] forKey:@"first"];
            [pDict setObject:@"office" forKey:@"type"];
            [pArray addObject:pDict];

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
    return [_messageArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    headerLabel.text = [NSString stringWithFormat:@"%@, %@", [[[_messageArray objectAtIndex:section] objectAtIndex:0] valueForKey:@"last"], [[[_messageArray objectAtIndex:section] objectAtIndex:0] valueForKey:@"first"]];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // Add the label to the header view
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"type"];
    cell.detailTextLabel.text = [[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"phone"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[[_messageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"phone"]]]];

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

//
//  selectPlanYearViewController.m
//  HBXMobile
//
//  Created by John Boyd on 12/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "selectPlanYearViewController.h"

@interface selectPlanYearViewController ()

@end

@implementation selectPlanYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = [[UIScreen mainScreen] bounds];
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    UIImageView *pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,34,54)];
    pImageView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];//[UIColor whiteColor];
    
    pImageView.contentMode = UIViewContentModeCenter;
    
    
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
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(messageTable.frame.origin.x, messageTable.frame.origin.y + messageTable.frame.size.height + 2, messageTable.frame.size.width, 44)];
    cancelButton.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    cancelButton.layer.cornerRadius = 10;
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Roboto-BOLD" size:18];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    CGFloat headerHeight = 54.0f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, headerHeight)];
    UIView *headerContentView = [[UIView alloc] initWithFrame:headerView.bounds];
    headerContentView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    headerContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, messageTable.frame.size.width - 35 -35, headerHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Roboto-BOLD" size:15];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];//[UIColor colorWithRed:79.0f/255.0f green:148.0f/255.0f blue:205.0f/255.0f alpha:1.0f];//[UIColor darkGrayColor];
    label.text = _messageTitle;
    [headerContentView addSubview:label];
    
    [headerContentView addSubview:pImageView];
    
    [headerView addSubview:headerContentView];
    messageTable.tableHeaderView = headerView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  showPlanDetailViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/31/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "showPlanDetailViewController.h"
#import "MyPlanWebViewController.h"

@interface showPlanDetailViewController ()

@end

@implementation showPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    planDetailTable.frame = CGRectMake(0,120,screenSize.width,600);
    planType.frame = CGRectMake(screenSize.width - planType.frame.size.width - 10, planType.frame.origin.y, planType.frame.size.width, planType.frame.size.height);
    
    planDetailTable.layer.borderWidth = 0.5;
    
    detailData = [[NSMutableArray alloc] init];
    
    [detailData addObject:@"Primary Care Visit to Treat an Injury or Illness"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];
    
    [detailData addObject:@"Specialist Visit"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];
    
    [detailData addObject:@"Other Practitioner Office Visit (Nurse, Physician Assistant)"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];

    [detailData addObject:@"Outpatient Facility Fee (e.g. Ambulatory Surgery Center)"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];

    [detailData addObject:@"Outpatient Surgery Physician/Surgical Services"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];

    [detailData addObject:@"Hospice Services)"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];

    [detailData addObject:@"Routine Eye Exam (Adult)"];
    [detailData addObject:@"No Charge"];
    [detailData addObject:@"No Charge"];
    
    [detailData addObject:@"Urgent Care Centers or Facilities"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];
    
    [detailData addObject:@"Home Health Care Services"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];
    
    [detailData addObject:@"Emergency Room Services"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];
    
    [detailData addObject:@"Emergency Transportation/Ambulance"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];
    
    [detailData addObject:@"Inpatient Hospital Services"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];

    [detailData addObject:@"Inpatient Physician and Surgical Services"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];
    
    [detailData addObject:@"Skilled Nursing Facility"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];

    [detailData addObject:@"Prenatal and Postnatal Care"];
    [detailData addObject:@"No Charge"];
    [detailData addObject:@"No Charge"];
    
    [detailData addObject:@"Delivery and All Inpatient Services for Maternity Care"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];

    [detailData addObject:@"Mental/Behavioral Health Outpatient Services"];
    [detailData addObject:@"No Charge after deductible"];
    [detailData addObject:@"No Charge after deductible"];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Plan Detail PDF" style:UIBarButtonItemStyleBordered target:self action:@selector(btnItem1Pressed:)];

    self.navigationItem.rightBarButtonItem = rightButton;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Show Plan PDF"]) {
        
        // Get destination view
        MyPlanWebViewController *vc = [segue destinationViewController];
        vc.url = (NSString *)sender;
    }
}

- (IBAction)btnItem1Pressed:(id)sender
{
//    [self performSegueWithIdentifier:@"Show Plan PDF" sender:@"https://dc.checkbookhealth.org/hie/dc/2016/assets/pdfs/86052DC0400005-01.pdf"];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MyPlanWebViewController *selectPlanController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HBXMobile Web View"];
    selectPlanController.url = @"https://dc.checkbookhealth.org/hie/dc/2016/assets/pdfs/86052DC0400005-01.pdf";
    [self.navigationController pushViewController:selectPlanController animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    [planDetailTable reloadData];
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
//        [firstView setHidden:NO];
//        [secondView setHidden:YES];
//        [planDetailTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

    }
    else{
        //toggle the correct view to be visible
//        [firstView setHidden:YES];
//        [secondView setHidden:NO];
//        [planDetailTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [detailData count]/3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor lightGrayColor]];
    
    if (section == 0)
    {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(0,0,screenSize.width/2,36);
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"SERVICES YOU MAY NEED";
        [v addSubview:lbl];
        
        UILabel *lbl1 = [[UILabel alloc] init];
        lbl1.frame = CGRectMake(screenSize.width/2,0,screenSize.width/2,36);
        lbl1.font = [UIFont systemFontOfSize:14];
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.text = [planType titleForSegmentAtIndex:planType.selectedSegmentIndex];
        [v addSubview:lbl1];
    }
    return v;
}

- (UITableViewCell *) getCellContentViewNames:(NSString *)cellIdentifier
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,screenSize.width,50) reuseIdentifier:cellIdentifier];
    
    UILabel *lblTemp;
    
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    //Initialize Label with tag 10.                         //left Name
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, screenSize.width/2,44)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor blackColor]; //[UIColor colorWithRed:0.22 green:0.33 blue:0.63 alpha:1.0];
    lblTemp.tag = 10;
    lblTemp.numberOfLines = 0;
    lblTemp.hidden = FALSE;
    lblTemp.font = [UIFont systemFontOfSize:14];
    lblTemp.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:lblTemp];
    
    
    //RIGHT
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width/2, 0, screenSize.width/2, 44)];
    lblTemp.backgroundColor = [UIColor whiteColor];
    lblTemp.textColor = [UIColor blackColor];
    lblTemp.tag = 11;
    lblTemp.hidden = FALSE;
    lblTemp.numberOfLines = 0;
    lblTemp.textAlignment = NSTextAlignmentCenter;
    lblTemp.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lblTemp];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
  
        cell = [self getCellContentViewNames:simpleTableIdentifier];
        
    }
    
    UILabel *lblLeft = (UILabel *)[cell viewWithTag:10];
    UILabel *lblRight = (UILabel *)[cell viewWithTag:11];
    lblLeft.backgroundColor = [UIColor lightGrayColor];
    
    NSInteger selectedSegment = planType.selectedSegmentIndex;
    
    lblLeft.text = [detailData objectAtIndex:indexPath.row*3];
    lblRight.text = [detailData objectAtIndex:indexPath.row*3+1+selectedSegment];
    return cell;
}


@end

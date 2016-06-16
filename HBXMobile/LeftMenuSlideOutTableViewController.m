//
//  LeftMenuSlideOutTableViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/8/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "LeftMenuSlideOutTableViewController.h"

@interface LeftMenuSlideOutTableViewController ()

@end

@implementation LeftMenuSlideOutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, -80);
    self.tableView.contentInset = inset;
    

/*
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0,120, 420, 140)];
    darkView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:.4];
    //    [self.view addSubview:darkView];
    UIView *blueRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(10,20, 395, 100)];
    blueRoundedCornerView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(38/255.0) blue:(99/255.0) alpha:0.9];
    blueRoundedCornerView.layer.masksToBounds = NO;
    blueRoundedCornerView.layer.cornerRadius = 8.0;

    [self.tableView setBackgroundView:nil];
    [self.tableView  setBackgroundView:blueRoundedCornerView];//[[UIView alloc] init]];
    [self.tableView  setBackgroundColor:UIColor.lightGrayColor];
    //[self.tableView  setBackgroundColor:UIColor.clearColor];
    //   myCollection.backgroundColor = [UIColor clearColor];
*/    
    
 //   FXBlurView *wView = [[FXBlurView alloc] initWithFrame:CGRectMake(0,120, 420, 140)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    if (section == 0)
//    return 2;
    
    return 1;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
/*
        if (indexPath.section == 0)
        {
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - 40 , 6, cell.frame.size.width - 40, cell.frame.size.height)];
            [switchview addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
            switchview.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"useEnrollDB"];
            
            [cell.contentView addSubview:switchview];
        }
*/
    }
    

    //cell.frame = CGRectMake(0,0, self.view.frame.size.width - 250, self.view.frame.size.height);
    /*
    if ([indexPath section] == 0 && [indexPath row] == 0)
        cell.textLabel.text = @"View Coverage"; //[NSString stringWithFormat:@"View Coverage, indexPath.row];
    else if ([indexPath section] == 0 && [indexPath row] == 1)
        cell.textLabel.text = @"Notifications";
    else
        */


        cell.textLabel.text = @"Logout";
    
//    if ([indexPath row] == 5 && !self.iLevel)
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [tableView beginUpdates];
//    [self performSegueWithIdentifier:@"Personal Information" sender:nil];
//[self.navigationController popViewControllerAnimated:YES];
    
 //   [tableView endUpdates];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UIViewController *vc ;
/*
    if ([indexPath section] == 0 && [indexPath row] == 1)
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"Show Notifications"];
    
    if ([indexPath section] == 0 && [indexPath row] == 1)
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"Show Notifications"];
 */
    if ([indexPath section] == 0)
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainLogin"];
    
    
    [[SlideNavigationController sharedInstance] pushViewController:vc animated:TRUE];
     
/*
    [[hbxNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:TRUE //self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
 */
}
@end

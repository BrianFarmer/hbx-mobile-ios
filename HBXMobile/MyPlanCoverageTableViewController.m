//
//  MyPlanCoverageTableViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/16/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "MyPlanCoverageTableViewController.h"
#import "MyPlanWebViewController.h"

@interface MyPlanCoverageTableViewController ()

@end

@implementation MyPlanCoverageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    

        cell.textLabel.numberOfLines = 0;
        if ([indexPath row] == 0 && [indexPath section] == 0)
        {
            cell.textLabel.text = @"Summary of Benefits and Coverage";
//            cell.detailTextLabel.text = @"abc12-bfg";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
            cell.textLabel.text = @"CareFirst Website";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    
    NSURL *targetURL = [NSURL URLWithString:@"https://dc.checkbookhealth.org/hie/dc/2016/assets/pdfs/86052DC0400005-01.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    */
    if ([indexPath row] == 0 && [indexPath section] == 0)
        [self performSegueWithIdentifier:@"Show Plan PDF" sender:@"https://dc.checkbookhealth.org/hie/dc/2016/assets/pdfs/86052DC0400005-01.pdf"];
    else
    {
        NSURL *url = [NSURL URLWithString:@"https://individual.carefirst.com/individuals-families/home.page"];
        
        if (![[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        }
//        [self performSegueWithIdentifier:@"Show Plan PDF" sender:@"https://individual.carefirst.com/individuals-families/home.page"];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Show Plan PDF"]) {
        
        // Get destination view
        MyPlanWebViewController *vc = [segue destinationViewController];
        vc.url = (NSString *)sender;
        
        // Get button tag number (or do whatever you need to do here, based on your object
 //       NSInteger tagIndex = [(UIButton *)sender tag];
        
        // Pass the information to your destination view
        //        [vc setSelectedButton:tagIndex];
    }
}

@end

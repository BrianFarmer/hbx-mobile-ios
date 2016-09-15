//
//  CarrierListViewController.m
//  HBXMobile
//
//  Created by John Boyd on 7/19/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "CarrierListViewController.h"
#import "SlideNavigationController.h"

@interface CarrierListViewController ()

@end

@implementation CarrierListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; //[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    self.navigationController.navigationItem.title = @"Carriers";
    
    tblCarriers.frame = CGRectMake(0,0,self.view.frame.size.width - 60,self.view.frame.size.height);
    
    [tblCarriers setBackgroundView:nil];
    [tblCarriers setBackgroundColor:[UIColor clearColor]];  //[UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:1.0]];
    [tblCarriers setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light_blue_gradient.png"]]];  //[UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:1.0]];

    NSURL *url = [NSURL URLWithString:@"https://dchealthlink.com/shared/json/carriers.json"];
    data = [NSData dataWithContentsOfURL:url];
    
    if (data != nil)
    {
        NSError *error = nil;
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.4];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    
    cell.textLabel.textColor = [UIColor whiteColor]; //[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]; //[UIColor redColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor]; //[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    
    NSArray *pItem = [dictionary allValues][indexPath.row];
    cell.textLabel.text = [pItem valueForKey:@"name"];
    cell.detailTextLabel.text = [pItem valueForKey:@"phone_brokers"];
    if ([cell.detailTextLabel.text length] == 0)
        cell.detailTextLabel.text = [pItem valueForKey:@"phone"];        
    
    /*
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Aetna";
        cell.detailTextLabel.text = @"1-855-319-7290";
    }
    
    if (indexPath.row == 1)
    {
        cell.textLabel.text = @"CareFirst";
        cell.detailTextLabel.text = @"1-855-444-3119";
    }
    
    if (indexPath.row == 2)
    {
        cell.textLabel.text = @"Kaiser Permanente";
        cell.detailTextLabel.text = @"1-800-777-7902";
    }
    
    if (indexPath.row == 3)
    {
        cell.textLabel.text = @"UnitedHealthcare";
        cell.detailTextLabel.text = @"1-877-856-2430";
    }
    */
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Call Carrier"
                                          message:cell.textLabel.text
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
                            //           [SlideNavigationController sharedInstance].menuRevealAnimationDuration = animationDuration;
                               //        [SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
                                   }];

                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cell.detailTextLabel.text]]];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end

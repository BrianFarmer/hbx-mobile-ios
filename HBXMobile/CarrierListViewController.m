//
//  CarrierListViewController.m
//  HBXMobile
//
//  Created by John Boyd on 7/19/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "CarrierListViewController.h"
#import "SlideNavigationController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

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
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = tblCarriers.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x003D62) CGColor], (id)[UIColorFromRGB(0x0074BA) CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];

    NSURL *url = [NSURL URLWithString:@"https://dchealthlink.com/shared/json/carriers.json"];
    data = [NSData dataWithContentsOfURL:url];
    
    NSMutableArray *healthArray = [[NSMutableArray alloc] init];
    NSMutableArray *dentalArray = [[NSMutableArray alloc] init]; 
    
    if (data != nil)
    {
        NSError *error = nil;
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"%@", dictionary);
//        for (NSDictionary *itemDict in dictionary)
        for (NSString *itemDict in dictionary)
        {
            NSLog(@"%@",itemDict);
            
            NSArray *pp = [dictionary valueForKey:itemDict];
            NSArray *name = [pp valueForKey:@"plans"];
            for (int yy=0;yy<[name count];yy++)
            {
                NSString *stype = [name objectAtIndex:yy];
                if ([stype isEqualToString:@"health"])
                    [healthArray addObject:pp];
                else
                    [dentalArray addObject:pp];
            }
            NSLog(@"%@",name);
        }

    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];

    planTypes = [NSArray arrayWithObjects:[healthArray sortedArrayUsingDescriptors:@[sort]], [dentalArray sortedArrayUsingDescriptors:@[sort]], nil];
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
    return [planTypes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[planTypes objectAtIndex:section] count];//[dictionary count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Health";
            break;
        case 1:
            sectionName = @"Dental";
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }

    cell.backgroundColor = [UIColor clearColor];

    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor redColor];
    [cell setSelectedBackgroundView:bgColorView];
    
//    cell.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.4];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    
    cell.textLabel.textColor = [UIColor whiteColor]; //[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]; //[UIColor redColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor]; //[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    
    NSArray *pItem = [[planTypes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];//    [dictionary allValues][indexPath.row];
    cell.textLabel.text = [pItem valueForKey:@"name"];
    cell.detailTextLabel.text = [pItem valueForKey:@"phone_brokers"];
    if ([cell.detailTextLabel.text length] == 0)
        cell.detailTextLabel.text = [pItem valueForKey:@"phone"];        
    
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

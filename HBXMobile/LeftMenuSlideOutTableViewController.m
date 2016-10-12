//
//  LeftMenuSlideOutTableViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/8/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "LeftMenuSlideOutTableViewController.h"
#import "CarrierListViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface LeftMenuSlideOutTableViewController ()

@end

@implementation LeftMenuSlideOutTableViewController

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.sectionFooterHeight = 0.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_blue_gradient.png"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 350.0f)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.tableView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x003D62) CGColor], (id)[UIColorFromRGB(0x0074BA) CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];

 //   [self.navigationController.navigationBar setBackgroundImage:[self imageFromColor:UIColorFromRGB(0x0077be)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
//    self.view.backgroundColor = UIColorFromRGB(0x0077be); //[UIColor colorWithPatternImage:[UIImage imageNamed:@"light_blue_gradient.png"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x003D62);//[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"light_blue_gradient.png"]]; //[UIColor clearColor]; //[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
/*
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, -80);
    self.tableView.contentInset = inset;
*/
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];  //[UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:1.0]];
//    self.tableView.backgroundView = view;
    //    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light_blue_gradient.png"]]];  //[UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:1.0]];

    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(-20,40,380,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
    lbNavTitle.text = NSLocalizedString(@"Menu",@"");
    lbNavTitle.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lbNavTitle;

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

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0)
//        return 2;
    
    if (section == 2)
        return 2;
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
        return 90;
    
    return 54;
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
- (UIView*)tableView:(UITableView*)tableView
viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)tableView:(UITableView*)tableView
viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2)
        return 50;
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
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
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 180, 70)]; // your cell's height should be greater than 48 for this.
        imgView.tag = 1;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        [cell.contentView addSubview:imgView];
        
 //       imgView = nil;
        /*
        UIButton *pbut = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 150, 60)];
        imgView.tag = 2;
        UIImageView *imgVew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        imgVew.backgroundColor = [UIColor clearColor];
        imgVew.image = [UIImage imageNamed:@"phoneWHT.png"];
        imgVew.contentMode = UIViewContentModeScaleAspectFit;
        pbut.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [pbut setImage:[UIImage imageNamed:@"phoneWHT.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:pbut];
        */
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];

    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor]; //[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.4];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor redColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = @"Carriers";
 //       cell.imageView.image = [UIImage imageNamed:@"list_icon.png"];
/*
        if (indexPath.row == 1)
        {
            cell.textLabel.text = @"Call Customer Service";
            cell.imageView.image = [UIImage imageNamed:@"menu_phone.png"];
        }
 */
        CALayer *separator = [CALayer layer];
        separator.backgroundColor = [UIColorFromRGB(0x0074BA) CGColor];
        separator.frame = CGRectMake(0, 53, self.view.frame.size.width, 1);
        [cell.layer addSublayer:separator];
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"Logout";
//        cell.imageView.image = [UIImage imageNamed:@"logout-512.png"];
        CALayer *separator = [CALayer layer];
        separator.backgroundColor = [UIColorFromRGB(0x0074BA) CGColor];
        separator.frame = CGRectMake(0, 53, self.view.frame.size.width, 1);
        [cell.layer addSublayer:separator];

    }
    else
    {
//        cell.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.4];
//        cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);

        if (indexPath.row == 0)
        {
            UIImageView *_imgView = (UIImageView *)[cell.contentView viewWithTag:1];
            _imgView.image = [UIImage imageNamed:@"DCHealthLink_LogoWHT1.png"]; //[UIImage imageNamed:@"callus80x80.png"];
            //        [_imgView setImage:[UIImage imageNamed:@"DCHealthLink_LogoWHT1.png"]]; //[UIImage imageNamed:@"callus80x80.png"]
           // cell.imageView.image = [UIImage imageNamed:@"DCHealthLink_LogoWHT1.png"];
            cell.imageView.contentMode = UIViewContentModeLeft;
        }
        else
        {
        //    cell.imageView.image = [UIImage imageNamed:@"callus80x80.png"];
            UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 70, 70)];
            [button addTarget:self
                       action:@selector(phoneUS:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"callus54x54.png"] forState:UIControlStateNormal];
//            [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 50.0, 0.0, 50.0)];
//            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 50.0, 0.0, 0.0)];
            
            button.backgroundColor = [UIColor clearColor];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     //       button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
            [button setTitle:@"Call Us" forState:UIControlStateNormal];
       //     [button setImage:[UIImage imageNamed:@"phoneWHT1.png"] forState:UIControlStateNormal];
            button.contentMode = UIViewContentModeCenter;// UIViewContentModeScaleAspectFit;
            
            CGSize imageSize = button.imageView.frame.size;
            CGSize titleSize = button.titleLabel.frame.size;
            
            CGFloat totalHeight = (imageSize.height + titleSize.height + 6);
            
            button.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height),
                                                    0.0f,
                                                    0.0f,
                                                    - titleSize.width);
            
            button.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                                    - imageSize.width - 2,
                                                    - (totalHeight - titleSize.height),
                                                    0.0f);
            [cell.contentView addSubview:button];
            
            UIButton *button1  = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 70, 70)];
            [button1 addTarget:self
                       action:@selector(emailUS:)
             forControlEvents:UIControlEventTouchUpInside];
            [button1 setImage:[UIImage imageNamed:@"emailus54x54.png"] forState:UIControlStateNormal];
            //            [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 50.0, 0.0, 50.0)];
            //            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 50.0, 0.0, 0.0)];
            
            button1.backgroundColor = [UIColor clearColor];
            button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //       button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
            [button1 setTitle:@"Email Us" forState:UIControlStateNormal];
            //     [button setImage:[UIImage imageNamed:@"phoneWHT1.png"] forState:UIControlStateNormal];
            //   button.contentMode = UIViewContentModeScaleAspectFit;
            
             imageSize = button1.imageView.frame.size;
             titleSize = button1.titleLabel.frame.size;
            
             totalHeight = (imageSize.height + titleSize.height + 6);
            
            button1.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height),
                                                      0.0f,
                                                      0.0f,
                                                      - titleSize.width);
            
            button1.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                                      - imageSize.width-8,
                                                      - (totalHeight - titleSize.height),
                                                      0.0f);
            [cell.contentView addSubview:button1];

        }
 
    }
//    if ([indexPath row] == 5 && !self.iLevel)
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)phoneUS:(id)sender
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Call Customer Service"
                                          message:@"1(855) 532-5465"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
                                   }];
                                   
                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"1(855) 532-5465"]]];
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

-(void)emailUS:(id)sender
{
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=Hello from HBX!", @"john.boyd3@dc.gov"];
    NSString *body = @"&body=It is sunny in DC!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];

}

-(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    UIGraphicsBeginImageContextWithOptions(image.size, YES, 0.0f);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    
    UIFont *font = [UIFont boldSystemFontOfSize:12];
//    if([text respondsToSelector:@selector(drawInRect:withAttributes:)])
//    {
        //iOS 7
        NSDictionary *att = @{NSFontAttributeName:font};
        [text drawInRect:rect withAttributes:att];
//    }
//    else
//    {
        //legacy support
//        [text drawInRect:CGRectIntegral(rect) withFont:font];
//    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [tableView beginUpdates];
//    [self performSegueWithIdentifier:@"Personal Information" sender:nil];
//[self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 //   [tableView endUpdates];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
//    UIViewController *vc ;
/*
    if ([indexPath section] == 0 && [indexPath row] == 1)
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"Show Notifications"];
    
    if ([indexPath section] == 0 && [indexPath row] == 1)
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"Show Notifications"];
 */
    if ([indexPath section] == 1)
    {
        if ([indexPath row] == 0)
        {
     //       vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainLogin"];
     //       [[SlideNavigationController sharedInstance] pushViewController:vc animated:NO];
    //        [[SlideNavigationController sharedInstance] popViewControllerAnimated:TRUE];
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:TRUE];
        }
    }
    else
    {
        if ([indexPath row] == 0)
        {
            CarrierListViewController *lf = [mainStoryboard instantiateViewControllerWithIdentifier: @"CarrierListMenu"];
            //UIViewController *lf = [[UIViewController alloc] init]; //]WithFrame:CGRectMake(0,0,200,200)];
        
            //[[SlideNavigationController sharedInstance].navigationController pushViewController:lf animated:TRUE];
            [self.navigationController pushViewController:lf animated:YES];
            //[[SlideNavigationController sharedInstance] pushViewController:lf animated:TRUE];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Call Customer Service"
                                                  message:@"1(855) 532-5465"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                           [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
                                           }];
                                           
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"1(855) 532-5465"]]];
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
    }
    
//    [[SlideNavigationController sharedInstance] pushViewController:vc animated:TRUE];
     
/*
    [[hbxNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:TRUE //self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
 */
}
@end



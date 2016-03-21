//
//  hbxNotificationsTableViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/11/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "hbxNotificationsTableViewController.h"
#import "startUploadOfDocumentViewController.h"

@interface hbxNotificationsTableViewController ()

@end

@implementation hbxNotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    proofArray = [NSArray arrayWithObjects:@"Utility Bill", @"Utility bill (water, gas, electric, oil, or cable), with name and address, issued within the last 60 days (disconnect notices/bills are not accepted)", @"Telephone Bill", @"Telephone bill (cell phone, wireless, or pager bills acceptable), reflecting applicant's name and current address, issued within the last 60 days (disconnect notices/bills are not accepted)", @"Mortgage Deed", @"Deed, mortgage, or settlement agreement reflecting applicant's name and property address issued within the last 60 days", nil];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
 //   [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setTitle:@"Notifications"];
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

    if (self.level == 1)
        return [proofArray count] / 2;
    
    return 2;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.level == 1)
    {
    NSString *cellText = [proofArray objectAtIndex:indexPath.row*2+1];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:cellText
     attributes:@
     {
     NSFontAttributeName: cellFont
     }];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size.height + 64;
    }
    
    return 74;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        if (self.level == 0)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
    }
    
//     cell.textLabel.font = [UIFont systemFontOfSize:16];
    if (self.level == 1)
    {
        cell.detailTextLabel.numberOfLines=0;
        cell.textLabel.text = [proofArray objectAtIndex:indexPath.row*2];
        cell.detailTextLabel.text = [proofArray objectAtIndex:indexPath.row*2+1];
    }
    else
    {
        cell.textLabel.numberOfLines = 0;
        if ([indexPath row] == 0)
        {
            cell.textLabel.text = @"You need to upload your Proof of Residency";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
            cell.textLabel.text = @"Your enroll period will start on April 1st, 2016";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.level == 1)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
         #if !(TARGET_IPHONE_SIMULATOR)
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
            [myAlertView show];
#else
            startUploadOfDocumentViewController *yourViewController = [[startUploadOfDocumentViewController alloc] init];
            yourViewController.view.frame = CGRectMake(0, 0, 400, 800);
            [self.navigationController pushViewController:yourViewController animated:YES];
  //                      [self.view presentViewController:yourViewController animated:YES completion:NULL];
            
#endif
        }
        else
        {
        
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
            [self presentViewController:picker animated:YES completion:NULL];
        
        }
    }
    else
    {
        if ([indexPath row] == 0)
        {
        hbxNotificationsTableViewController *yourViewController = [[hbxNotificationsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        yourViewController.level = 1;
        [self.navigationController pushViewController:yourViewController animated:YES];
        }
    }
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 /*
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
 */
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
//    startUploadOfDocumentViewController *yourViewController = [[startUploadOfDocumentViewController alloc] init];
//    [self.navigationController pushViewController:yourViewController animated:YES];
    
    [self.navigationController popViewControllerAnimated:NO];
 
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                          message:@"You have uploaded ypur document"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    
    [myAlertView show];
    

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end

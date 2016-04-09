//
//  hbxNotificationsTableViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/11/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "hbxNotificationsTableViewController.h"
#import "startUploadOfDocumentViewController.h"

@interface hbxNotificationsTableViewController ()

@property (nonatomic) UIImagePickerController *imagePickerController;

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
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UIViewController *students = [mainStoryboard instantiateViewControllerWithIdentifier:@"StartUpload"];
            [self.navigationController pushViewController:students animated:YES];
            
//            startUploadOfDocumentViewController *yourViewController = [[startUploadOfDocumentViewController alloc] init];
 //           yourViewController.view.frame = CGRectMake(0, 0, 400, 800);
 //           [self.navigationController pushViewController:yourViewController animated:YES];
            
//            hbxNotificationsTableViewController *yourViewController = [[hbxNotificationsTableViewController alloc] initWithStyle:UITableViewStylePlain];
//            yourViewController.level = 1;
//            [self.navigationController pushViewController:yourViewController animated:YES];

  //                      [self.view presentViewController:yourViewController animated:YES completion:NULL];
            
#endif
        }
        else
        {
        
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
//            picker.
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerCameraCaptureModePhoto];
            picker.showsCameraControls=NO;
//            overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];

            picker.allowsEditing = NO;
            picker.delegate = self;

            UIView *main_overlay_view = [[UIView alloc] initWithFrame:self.view.bounds];
            
            // Clear view (live camera feed) created and added to main overlay view
            // ------------------------------------------------------------------------
            UIView *clear_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            clear_view.opaque = NO;
            clear_view.backgroundColor = [UIColor clearColor];
            [main_overlay_view addSubview:clear_view];
            
 //           picker.cameraOverlayView = overlay.view;
 //           UIView *overlay_view = [self createCustomOverlayView];
     //       for(int i = 0; i < 2; i++) {
   //             self.HeightOfButtons = 100;
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                // when a button is touched, UIImagePickerController snaps a picture
            [button addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake( self.view.frame.size.width / 2 - 150, self.view.frame.size.height - 100, 300, 75);
            //[button setBackgroundColor:[UIColor lightGrayColor]];
            button.layer.cornerRadius = 10; // this value vary as per your desire
            button.clipsToBounds = YES;
            button.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.5];
            [button setImage:[self imageFromSystemBarButton:UIBarButtonSystemItemCamera]
                         forState:UIControlStateNormal];

                [main_overlay_view addSubview:button];
      //      }
            [picker setCameraOverlayView:main_overlay_view];
            
            self.imagePickerController = picker;
            
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

- (UIImage *)imageFromSystemBarButton:(UIBarButtonSystemItem)systemItem {
    // Holding onto the oldItem (if any) to set it back later
    // could use left or right, doesn't matter
    UIBarButtonItem *oldItem = self.navigationItem.rightBarButtonItem;
    
    UIBarButtonItem *tempItem = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:systemItem
                                 target:nil
                                 action:nil];
    
    // Setting as our right bar button item so we can traverse its subviews
    self.navigationItem.rightBarButtonItem = tempItem;
    
    // Don't know whether this is considered as PRIVATE API or not
    UIView *itemView = (UIView *)[self.navigationItem.rightBarButtonItem performSelector:@selector(view)];
    
    UIImage *image = nil;
    // Traversing the subviews to find the ImageView and getting its image
    for (UIView *subView in itemView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            image = ((UIImageView *)subView).image;
            break;
        }
    }
    
    // Setting our oldItem back since we have the image now
    self.navigationItem.rightBarButtonItem = oldItem;
    
    return image;
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

    
    
}

//********** TAKE PICTURE **********
-(void)takePicture12:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    //Use camera if device has one otherwise use photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    //Show image picker
    [self presentModalViewController:imagePicker animated:YES];
    //Modal so we wait for it to complete
}

- (void)takePicture:(id)sender{
    [self.imagePickerController takePicture];
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    UIViewController *startUpload = [mainStoryboard instantiateViewControllerWithIdentifier:@"StartUpload"];
//    [self.navigationController pushViewController:startUpload animated:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage]; //info[UIImagePickerControllerOriginalImage]; //[UIImagePickerControllerEditedImage];

    CGFloat width = chosenImage.size.width;
    CGFloat height = chosenImage.size.height;
    
//    UIImage *initialImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    NSData *data = UIImagePNGRepresentation(initialImage);
    
//    CGFloat gg = initialImage.scale;
/*
    initialImage = [UIImage imageWithCGImage:[UIImage imageWithData:data].CGImage
                                       scale:2
                                 orientation:initialImage.imageOrientation];
*/
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[chosenImage CGImage]
                        scale:(chosenImage.scale * 2.0)
                  orientation:(chosenImage.imageOrientation)];
    
    width = scaledImage.size.width;
    height = scaledImage.size.height;
//    self.imageView.image = scaledImage;
    
 
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    startUploadOfDocumentViewController *startUpload = [mainStoryboard instantiateViewControllerWithIdentifier:@"StartUpload"];
    
//    startUpload.imageView.image = scaledImage;
    startUpload.selectedImage = scaledImage;
    
    [self.navigationController pushViewController:startUpload animated:YES];

    [picker dismissViewControllerAnimated:YES completion:NULL];

    return;
    
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

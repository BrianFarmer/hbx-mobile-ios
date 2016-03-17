//
//  startUploadOfDocumentViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/17/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "startUploadOfDocumentViewController.h"
#import <AWSS3/AWSS3.h>
#import "Constants.h"

@interface startUploadOfDocumentViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (copy, nonatomic) AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler;
@property (copy, nonatomic) AWSS3TransferUtilityUploadProgressBlock uploadProgress;

@end

@implementation startUploadOfDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)upload:(AWSS3TransferManagerUploadRequest *)uploadRequest {
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
//    __weak UploadViewController *weakSelf = self;
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            UploadViewController *strongSelf = weakSelf;
//                            NSUInteger index = [strongSelf.collection indexOfObject:uploadRequest];
//                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
//                                                                        inSection:0];
//                            [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                        });
                    }
                        break;
                        
                    default:
                        NSLog(@"Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                NSLog(@"Upload failed: [%@]", task.error);
            }
        }
        
        if (task.result) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                UploadViewController *strongSelf = weakSelf;
//                NSUInteger index = [strongSelf.collection indexOfObject:uploadRequest];
//                [strongSelf.collection replaceObjectAtIndex:index withObject:uploadRequest.body];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
//                                                            inSection:0];
//                [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
        }
        
        return nil;
    }];
}

- (IBAction)startUploadClick:(id)sender
{
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.uploadProgress = self.uploadProgress;
    
    UIImage *image = [UIImage imageNamed:@"dchealthlink.jpg"];
    /*
     AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
     [[transferUtility uploadData:[dataString dataUsingEncoding:NSUTF8StringEncoding]
     bucket:S3BucketName
     key:S3UploadKeyName
     contentType:@"text/plain"
     expression:expression
     completionHander:self.completionHandler] continueWithBlock:^id(AWSTask *task) {
     if (task.error) {
     NSLog(@"Error: %@", task.error);
     }
     if (task.exception) {
     NSLog(@"Exception: %@", task.exception);
     }
     if (task.result) {
     dispatch_async(dispatch_get_main_queue(), ^{
     self.statusLabel.text = @"Uploading...";
     });
     }
     
     return nil;
     }];
     */
    
    //    UIImage *image = imageDictionary[UIImagePickerControllerOriginalImage];
    NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
    NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"upload"] stringByAppendingPathComponent:fileName];
    NSData * imageData = UIImagePNGRepresentation(image);
    
    [imageData writeToFile:filePath atomically:YES];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = fileName;
    uploadRequest.bucket = S3BucketName;
    
    //    [self.collection insertObject:uploadRequest atIndex:0];
    
    [self upload:uploadRequest];

}
@end

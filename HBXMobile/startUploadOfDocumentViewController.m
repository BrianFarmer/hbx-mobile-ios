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
    
 //   UIImage *image = [UIImage imageNamed:@"waterfall.png"];
//    UIImage *pi = self.selectedImage;
    
//    UIImage *smallImage = [self imageWithImage:self.sele size:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    UIImage *smallImage =
    [UIImage imageWithCGImage:[self.selectedImage CGImage]
                        scale:(self.selectedImage.scale * 3.0)
                  orientation:(self.selectedImage.imageOrientation)];
    
    self.imageView.image = smallImage;
    
    self.progressView.progress = 0.0f;
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"upload"]
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
        NSLog(@"Creating 'upload' directory failed: [%@]", error);
    }

}

- (UIImage *)imageWithImage:(UIImage *)sourceImage size:(CGSize)size {
    CGSize newSize = CGSizeZero;
    if ((sourceImage.size.width / size.width) < (sourceImage.size.height / size.height)) {
        newSize = CGSizeMake(sourceImage.size.width, size.height * (sourceImage.size.width / size.width));
    } else {
        newSize = CGSizeMake(size.width * (sourceImage.size.height / size.height), sourceImage.size.height);
    }
    
    CGRect cropRect = CGRectZero;
    cropRect.origin.x = (sourceImage.size.width - newSize.width) / 2.0f;
    cropRect.origin.y = (sourceImage.size.height - newSize.height) / 2.0f;
    cropRect.size = newSize;
    
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([sourceImage CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef];
    CGImageRelease(croppedImageRef);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0);
    [croppedImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(UIImage*) imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    
    __weak startUploadOfDocumentViewController *weakSelf = self;
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            startUploadOfDocumentViewController *strongSelf = weakSelf;
//                            NSUInteger index = [strongSelf.collection indexOfObject:uploadRequest];
//                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
//                                                                        inSection:0];
//                            [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                            /*
                            uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (totalBytesExpectedToSend > 0) {
                                        strongSelf.progressView.progress = (float)((double) totalBytesSent / totalBytesExpectedToSend);
                                    }
                                });
                            };
*/
            //                self.progressView.progress = (float)((double) totalBytesSent / totalBytesExpectedToSend);
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
//                startUploadOfDocumentViewController *strongSelf = weakSelf;
//                NSUInteger index = [strongSelf.collection indexOfObject:uploadRequest];
//                [strongSelf.collection replaceObjectAtIndex:index withObject:uploadRequest.body];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
//                                                            inSection:0];
//                [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                [self ddd:uploadRequest];

            });
                 
        }
   
        return nil;
    }];
                [self ddd:uploadRequest];
}

-(void)ddd:(AWSS3TransferManagerUploadRequest *)uploadRequest
{
       __weak startUploadOfDocumentViewController *weakSelf = self;
    startUploadOfDocumentViewController *strongSelf = weakSelf;
    uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (totalBytesExpectedToSend > 0) {
                strongSelf.progressView.progress = (float)((double) totalBytesSent / totalBytesExpectedToSend);
            }
        });
    };
    
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)startUploadClick:(id)sender
{
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.uploadProgress = self.uploadProgress;
    
    CGFloat pw = self.selectedImage.size.width;
    CGFloat ph = self.selectedImage.size.height;
    
    UIImage *pImg = [self resizeImage:self.selectedImage newSize:CGSizeMake(pw, ph)];
    pw = pImg.size.width;
    ph = pImg.size.height;
    
    NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".jpg"];
    NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"upload"] stringByAppendingPathComponent:fileName];
    NSData * imageData = UIImagePNGRepresentation(pImg);
    NSData * imageData1 = UIImageJPEGRepresentation(self.selectedImage, .6);
    
        [imageData1 writeToFile:filePath atomically:YES];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = fileName;
    uploadRequest.bucket = S3BucketName;
    

/*
     AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
     [[transferUtility upload:[uploadRequest dataUsingEncoding:NSUTF8StringEncoding]
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
 /*
    //    UIImage *image = imageDictionary[UIImagePickerControllerOriginalImage];
    NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
    NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"upload"] stringByAppendingPathComponent:fileName];
    NSData * imageData = UIImagePNGRepresentation(image);
    
    [imageData writeToFile:filePath atomically:YES];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = fileName;
    uploadRequest.bucket = S3BucketName;
*/
    //    [self.collection insertObject:uploadRequest atIndex:0];
    
    [self upload:uploadRequest];

}
@end

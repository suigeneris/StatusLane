//
//  HomePageInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "HomePageInteractor.h"
#import "HomePagePresenter.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>



@interface HomePageInteractor ()


@end


@implementation HomePageInteractor



#pragma mark - ImagePicker Delegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self.presenter setBackGroundImage:[self grayishImage:chosenImage]];
        
        
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.presenter dissmiss];
    
}




#pragma mark - Delegate Methods

-(BOOL)checkImagePickerSourceTypeAvailability:(Class )imagePickerClass{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        return YES;
    }
    
    else
    {
        return NO;
    }
    
}

-(NSString *)checkAuthorizationForSourceType:(UIImagePickerControllerSourceType)sourceType{
    
    NSString *accessGranted = [self getMediaAutorizationForMediaType:sourceType];

    return accessGranted;
}

-(void)openSettings{
    
    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:appSettings];
}

#pragma mark - Internal Methods

- (UIImage*) grayishImage: (UIImage*) inputImage {
    
    // Create a graphic context.
    UIGraphicsBeginImageContextWithOptions(inputImage.size, YES, 1.0);
    CGRect imageRect = CGRectMake(0, 0, inputImage.size.width, inputImage.size.height);
    
    // Draw the image with the luminosity blend mode.
    // On top of a white background, this will give a black and white image.
    [inputImage drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:0.3];
    
    // Get the resulting image.
    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return filteredImage;
    
}

-(NSString *)getMediaAutorizationForMediaType:(UIImagePickerControllerSourceType) sourceType {
    
    NSString * authorization;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        authorization = [self getAuthoriaztionToAccessCamera];
        
    }
    
    else {
        
        authorization = [self getAuthorizationToAccessPhotos];
    }
    
    return authorization;
}

-(NSString *)getAuthoriaztionToAccessCamera{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) {
        
        return @"Authorized";
        
    } else if(status == AVAuthorizationStatusDenied){
        
        return @"Denied";
        
    } else if(status == AVAuthorizationStatusRestricted){
        
        return @"Restricted";
        
    } else {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
        }];
        
        return @"Not Determined";
    }
    
    
}

-(NSString *)getAuthorizationToAccessPhotos{
    
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusAuthorized) {
         return @"Authorised";
    }
    
    else if (status == PHAuthorizationStatusRestricted){
        
        return @"Restricted";
    }
    else if (status == PHAuthorizationStatusDenied) {
        
        return @"Denied";
    }
    
    else {
        return @"Not Deternined";

    }

}

@end

//
//  HomePageInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "HomePageInteractor.h"
#import "HomePageDataSource.h"
#import "StatusListPresenterCell.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "RSKImageCropViewController.h"
#import "UIFont+StatusLaneFonts.h"
#import "UIColor+StatusLane.h"
#import "UIImage+StatusLane.h"
#import "Defaults.h"
#import <Parse/Parse.h>



@interface HomePageInteractor () 

@property (nonatomic, assign) int flagForAlertViewButton;
@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) HomePageDataSource *homePageDataSource;
@property (nonatomic, strong) NSArray *arrayofStatusTypes;
@property (nonatomic, strong) PFObject *partnerObject;
@property (nonatomic, strong) PFUser *partnerUser;


@end


@implementation HomePageInteractor

-(id<UITableViewDataSource>)dataSource{
    
    if (!_dataSource) {
        _dataSource = self.homePageDataSource;
        
    }
    
    return _dataSource;
}

-(HomePageDataSource *)homePageDataSource{
    
    if (!_homePageDataSource) {
        
        _homePageDataSource = [HomePageDataSource new];
    }
    
    return _homePageDataSource;
}


-(NSArray *)arrayofStatusTypes{
    
    if (!_arrayofStatusTypes) {
        
        _arrayofStatusTypes = @[@"SINGLE", @"MARRIED", @"DATING", @"RELATIONSHIP", @"SEEING", @"COMPLICATED", @"ENGAGED"];
    }
    
    return _arrayofStatusTypes;
}



#pragma mark - Tableview Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView reloadData];
    StatusListPresenterCell *cell = (StatusListPresenterCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.statusTypeLabel setFont:[UIFont statusLaneAsapBold:15]];
    cell.statusTypeLabel.textColor = [UIColor statusLaneGreen];
    cell.tickImageView.image = [UIImage imageNamed:@"Tick"];
    
    if (indexPath.row == 0) {
        [Defaults setStatus:cell.statusTypeLabel.text];
        [self.presenter hideTableView];
        [self.presenter changeUserStatusToSingle];
        [self.presenter resetImageViewsPostition];

    }
    
    else {
        
        [self.presenter indexPathForSelectedRow:indexPath];
        [self.presenter showChoosePartner];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(StatusListPresenterCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.statusTypeLabel.text = [self.arrayofStatusTypes objectAtIndex:indexPath.row];
    cell.statusTypeLabel.textColor = [UIColor blackColor];
    [cell.statusTypeLabel setFont:[UIFont statusLaneAsapRegular:15]];
    cell.tickImageView.image = [UIImage new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

}

#pragma mark - ImagePicker Delegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    __block UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:self.flagForAlertViewButton ? NO : YES completion:^{
    
        if (self.flagForAlertViewButton == 0) {
            
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
                
                chosenImage = [UIImage flipPicture:chosenImage];

            }
            
            [Defaults setBackgroundImage:[UIImage grayishImage:chosenImage]];
            [self.presenter setBackGroundImage];
            
        }
        
        else {
            
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
                
                chosenImage = [UIImage flipPicture:chosenImage];
                
            }
            [self.presenter showImageCropper:chosenImage];
            
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.presenter dismiss];
    
}


#pragma mark - Interactor Delegate Methods

-(BOOL)checkImagePickerSourceTypeAvailability:(Class)imagePickerClass{
    
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

-(int)setFlagForAlertViewButtonPressed:(int)interger{

    self.flagForAlertViewButton = interger;
    return self.flagForAlertViewButton;
}

-(UIImage *)returnBackgroundImageFromFile{
    
    UIImage *image = [Defaults backgroundImage];
    
    if (image) {
        return image;
    }
    
    else{
        
        UIImage *image = [UIImage imageNamed:@"Background 2"];
        return image;
    }
}

-(UIImage *)returnProfileImageFromFile{
    
    UIImage *image = [Defaults profileImage];
    
    if (image) {
        return image;
    }
    
    else{
        
        UIImage *image = [UIImage imageNamed:@"Default_Profile_Image"];
        return image;
    }
}

-(NSString *)returnUserStatusFromDefaults{
    
    if ([[Defaults status] isEqualToString:@"SINGLE"]) {
        return [Defaults status];
    }
    
    else {
        
        [self.presenter animateViews];
        return [Defaults status];
    }
    
}

-(NSString *)returnPartnerName{

    return [Defaults partnerFullName];
}

#pragma mark - Internal Methods

-(NSString *)getMediaAutorizationForMediaType:(UIImagePickerControllerSourceType)sourceType {
    
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


#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.presenter dissmissImageCropper];

}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    croppedImage = [UIImage imageWithImage:croppedImage scaledToSize:CGSizeMake(100, 100)];
    [Defaults setProfileImage:croppedImage];
    [self.presenter chooseProfileImage];
    [self.presenter dissmissImageCropper];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showChoosePartner"]) {

        NSLog(@"IS this called");

    }
}
@end

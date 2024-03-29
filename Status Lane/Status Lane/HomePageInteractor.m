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
#import "NetworkManager.h"
#import "PushNotificationManager.h"



@interface HomePageInteractor () {
    
    NSString *selectedStatus;
}

@property (nonatomic, assign) int flagForAlertViewButton;
@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) HomePageDataSource *homePageDataSource;
@property (nonatomic, strong) id <NetworkProvider> networkProvider;
@property (nonatomic) id <PushNotificationProvider> pushNotificationProvider;

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

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        _networkProvider = [NetworkManager new];
    }
    return _networkProvider;
}

-(id<PushNotificationProvider>)pushNotificationProvider{
    
    if (!_pushNotificationProvider) {
        
        _pushNotificationProvider = [PushNotificationManager new];
        
    }
    return _pushNotificationProvider;
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
        
        if ([[Defaults status] isEqualToString:cell.statusTypeLabel.text]) {
        
            [self.presenter hideTableView];
            [self.presenter changeUserStatusWithStatus:cell.statusTypeLabel.text];
            [self.presenter resetImageViewsPostition];
        }
        
        else{
            
            [self.presenter startAnimatingActivityView];
            selectedStatus = cell.statusTypeLabel.text;
            [self fetchUserObjectIfNeeded];
        }
        
    }
    else {
        
        if ([[Defaults status] isEqualToString:@"SINGLE"]) {
            [self.presenter indexPathForSelectedRow:indexPath];
            [self.presenter showChoosePartner];
        }
        else if ([[Defaults status] isEqualToString:cell.statusTypeLabel.text]){
            
            [self.presenter hideTableView];

        }
        else{
            
            [self.presenter startAnimatingActivityView];
            selectedStatus = cell.statusTypeLabel.text;
            [self fetchUserObjectIfNeeded];
        }
        
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
            [self createBackgroundTaskForImageUpload:chosenImage withImageName:@"userBackgroundPicture"];
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
-(void)fetchUserObjectIfNeeded{

    [self.networkProvider fetchCurrentUserWithSuccesss:^(id responseObject) {
        
        NSLog(@"Fetch current user success");
        PFUser *user = responseObject;
        [self updatePreviousPartnerOfUser:user];
        
    } andFailure:^(NSError *error) {
        
        NSLog(@"Fetch user failed with error: %@", error.localizedDescription);
        [self.presenter stopAnimatingActivitiyView];
        [self.presenter hideTableView];
        [self.presenter showErrorView:error.localizedDescription];
    }];
    
}
-(void)updatePreviousPartnerOfUser:(PFUser*)user{
    
    NSArray *partnerArray = user[@"partner"];

    if (partnerArray) {
        

        if (![[partnerArray objectAtIndex:0] isKindOfClass:NSClassFromString(@"PFUser")]) {
            
            NSLog(@"Is this called");

            PFObject *previousPartner = [partnerArray objectAtIndex:0];
            previousPartner[@"status"] = selectedStatus;
            if ([selectedStatus isEqualToString:@"SINGLE"]) {
                [previousPartner removeObject:user forKey:@"partner"];
            }
            [self.networkProvider saveWithPFObject:previousPartner
                                           success:^(id responseObject) {
                                               
                                               
                                               user[@"status"] = selectedStatus;
                                               if ([selectedStatus isEqualToString:@"SINGLE"]) {
                                                   [user removeObject:previousPartner forKey:@"partner"];
                                               }
                                               [self updatePFUserStatusWithUser:user];
                                        
                                           } failure:^(NSError *error) {
                                               
                                               [self.presenter stopAnimatingActivitiyView];
                                               [self.presenter hideTableView];
                                               [self.presenter showErrorView:error.localizedDescription];
                                               
                                           }];
            
        }
        
        else{
            
            NSLog(@"Previous partner is a user");
            [self notifyUserOfPartnerStatusChangeViaPushWithUser:user andPartner:[partnerArray objectAtIndex:0]];
        }
        
    }
    else{
        
        NSLog(@"NO PARTNER");
        [self.presenter stopAnimatingActivitiyView];
        [self.presenter changeUserStatusWithStatus:@"SINGLE"];
        [self.presenter hideTableView];
        [self.presenter resetImageViewsPostition];
    }
}

-(void)updatePFUserStatusWithUser:(PFUser *)user{
    
    NSLog(@"update pf user status with user called");
    [self.networkProvider saveWithPFObject:user
                                   success:^(id responseObject) {
                                       
                                       NSLog(@"update pf user status with user success");

                                       [Defaults setStatus:selectedStatus];
                                       [self.presenter changeUserStatusWithStatus:selectedStatus];
                                       if ([selectedStatus isEqualToString:@"SINGLE"]) {
                                           [self.presenter resetImageViewsPostition];

                                       }
                                       [self.presenter stopAnimatingActivitiyView];
                                       [self.presenter hideTableView];
                                       [self updateStatusHistoryForUser:user];
                                       
                                   } failure:^(NSError *error) {
                                       
                                       [self.presenter stopAnimatingActivitiyView];
                                       [self.presenter hideTableView];
                                       [self.presenter showErrorView:error.localizedDescription];
                                   }];
}

-(void)notifyUserOfPartnerStatusChangeViaPushWithUser:(PFUser *)user andPartner:(PFUser *)partner{
    
    PFUser *notifiedUser = partner;
    NSString *channel = [notifiedUser objectId];
    NSString *message = @"Your partner changed their status to SINGLE";
    
    NSDictionary *dictionary = @{
                                 @"alert" : message,
                                 @"badge" : @"Increment",
                                 @"channel" : channel,
                                 @"objectId" : [[PFUser currentUser] objectId],
                                 @"fullName" : [[PFUser currentUser] objectForKey:@"fullName"]
                                 };
    
    
    [self.pushNotificationProvider callCloudFuntionWithName:@"sendPushNotification"
                                                 parameters:dictionary
                                                    success:^(id responseObject) {
                                                        
                                                        [user removeObjectForKey:@"partner"];
                                                        user[@"status"] = selectedStatus;
                                                        [self updatePFUserStatusWithUser:user];
                                                        
                                                    } andFailure:^(NSError *error) {
                                                        
                                                        [self.presenter stopAnimatingActivitiyView];
                                                        [self.presenter hideTableView];
                                                        [self.presenter showErrorView:error.localizedDescription];
                                                        
                                                    }];
    
}

-(void)updateStatusHistoryForUser:(PFUser  *)user{
    
    //Check if user has a status history
    
    PFQuery *query = [PFQuery queryWithClassName:@"StatusHistory"];
    [query whereKey:@"historyId" equalTo:user.objectId];
    [query orderByDescending:@"statusDate"];
    
    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                             
                                             NSArray *array = responseObject;
                                             if (array.count > 0) {
                                                 //User has a history, so send the end date of the last relationship
                                                 PFObject *object = [array objectAtIndex:0];
                                                 object[@"statusEndDate"] = [NSDate date];
                                                 NSString *lastPartnerId = object[@"partnerId"];
                                                 NSString *lastPartnerName = object[@"partnerName"];
                                                 [object saveInBackground];
                                                 
                                                 //Then create the new history
                                                 PFObject *statusHistoryObject = [PFObject objectWithClassName:@"StatusHistory"];
                                                 statusHistoryObject[@"historyId"] = user.objectId;
                                                 statusHistoryObject[@"partnerId"] = lastPartnerId;
                                                 statusHistoryObject[@"partnerName"] = lastPartnerName;
                                                 statusHistoryObject[@"fullName"] = user[@"fullName"];
                                                 statusHistoryObject[@"statusType"] = user[@"status"];
                                                 statusHistoryObject[@"statusDate"] = [NSDate date];
                                                 [statusHistoryObject saveInBackground];
                                                 
                                             }
                                             else{
                                                 
                                                 //User has no history so create history as normal
                                                 PFObject *statusHistoryObject = [PFObject objectWithClassName:@"StatusHistory"];
                                                 statusHistoryObject[@"historyId"] = user.objectId;
                                                 statusHistoryObject[@"statusType"] = user[@"status"];
                                                 statusHistoryObject[@"statusDate"] = [NSDate date];
                                                 [statusHistoryObject saveInBackground];
                                             }
                                             
                                         } failure:^(NSError *error) {
                                             
                                             NSLog(@"This is the error %@", error.localizedDescription);
                                         }];

}

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
    [self createBackgroundTaskForImageUpload:croppedImage withImageName:@"userProfilePicture"];
    [self.presenter chooseProfileImage];
    [self.presenter dissmissImageCropper];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showChoosePartner"]) {

    }
}


#pragma mark - Image Upload

-(void)createBackgroundTaskForImageUpload:(UIImage *)image withImageName:(NSString *)name{
    
    UIBackgroundTaskIdentifier backgoundTask;
    backgoundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        [[UIApplication sharedApplication] endBackgroundTask:backgoundTask];
    }];
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self updatePFUserImageWithImage:image andImageName:name];
        [[UIApplication sharedApplication]endBackgroundTask:backgoundTask];
        
        
    });
}

-(void)updatePFUserImageWithImage:(UIImage *)image andImageName:(NSString *)name{
    
    if ([UIImage isImageToLarge:image]) {
        
        image = [UIImage shrinkImage:image];
        
    }
    
    NSData *backgroundImageData = UIImagePNGRepresentation(image);
    PFFile *backgroundImageFile = [PFFile fileWithData:backgroundImageData];
    
    [backgroundImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            PFUser *user = [PFUser currentUser];
            [user setObject:backgroundImageFile forKey:name];
            [user saveEventually:^(BOOL suceeded, NSError *error){
                
                if (succeeded) {
                    NSLog(@"Image uploaded");
                    
                }
                
                else{
                    
                    NSLog(@"%@", [error userInfo]);
                }
                
                
            }];
            
        }
        
        else{
            
            NSLog(@"Error from saving file: %@", [error userInfo]);
            
        }
        
    }];
}

@end








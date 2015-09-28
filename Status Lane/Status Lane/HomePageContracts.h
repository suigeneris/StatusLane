//
//  HomePageContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^AlertControllerBlock)(void);

@protocol HomePageDataSource <NSObject>

-(id<UITableViewDataSource>) dataSource;

@end
@protocol HomePageInteractorDelegate <NSObject>

-(BOOL)checkImagePickerSourceTypeAvailability:(Class )imagePickerClass;
-(NSString *)checkAuthorizationForSourceType:(UIImagePickerControllerSourceType)sourceType;
-(void)openSettings;
-(int)setFlagForAlertViewButtonPressed:(int)interger;
-(UIImage *)returnBackgroundImageFromFile;
-(UIImage *)returnProfileImageFromFile;
-(NSString *)returnUserStatusFromDefaults;
-(NSString *)returnPartnerName;



@end

@protocol HomePagePresenterDelegate <NSObject>

-(void)showAlertWithTitle:(NSString *)title errorMessage:(NSString *)error actionTitle:(NSString *)actionTitle withStyle:(UIAlertControllerStyle)style withBlock:(AlertControllerBlock)alertViewBlock;
-(void)dismiss;
-(void)showChoosePartner;
-(void)setBackGroundImage;
-(void)chooseProfileImage;
-(void)showImageCropper:(UIImage *)image;
-(void)dissmissImageCropper;
-(void)hideTableView;
-(void)indexPathForSelectedRow:(NSIndexPath*)indexPath;
-(void)changeUserStatusWithStatus:(NSString *)status;
-(void)animateViews;
-(void)resetImageViewsPostition;
-(void)startAnimatingActivityView;
-(void)stopAnimatingActivitiyView;
-(void)showErrorView:(NSString *)errorMessage;


@end
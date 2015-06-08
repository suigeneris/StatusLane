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


@protocol HomePageInteractorDelegate <NSObject>

-(BOOL)checkImagePickerSourceTypeAvailability:(Class )imagePickerClass;
-(NSString *)checkAuthorizationForSourceType:(UIImagePickerControllerSourceType)sourceType;
-(void)openSettings;
-(int)setFlagForAlertViewButtonPressed:(int)interger;

@end

@protocol HomePagePresenterDelegate <NSObject>

-(void)showAlertWithTitle:(NSString *)title errorMessage:(NSString *)error actionTitle:(NSString *)actionTitle withStyle:(UIAlertControllerStyle)style withBlock:(AlertControllerBlock)alertViewBlock;
-(void)dissmiss;
-(void)setBackGroundImage:(UIImage *)image;
-(void)chooseProfileImage:(UIImage *)image;
-(void)showImageCropper:(UIImage *)image;
-(void)dissmissImageCropper;

@end
//
//  VerifyAccountContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 21/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VerifyAccountInteractor <NSObject>


-(NSString *)resendVerificationCodeToNumber:(NSString*)number;
-(void)attemptRegisterUserWithUsername:(NSString *)username andPassword:(NSString *)password;

@end


@protocol VerifyAccountPresenter <NSObject>

-(void)showErrorViewWithMessage:(NSString *)message;
-(void)createAccountSuccessfull;
-(void)showActivityView;
-(void)hideActivityView;


@end
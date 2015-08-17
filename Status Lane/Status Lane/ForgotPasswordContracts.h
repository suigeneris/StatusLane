//
//  ForgotPasswordContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ForgotPasswordInteractor <NSObject>

-(NSString *)requestCountryCode;
-(void)queryUsernameFor:(NSString *)username;

@end


@protocol ForgotPasswordPresenter <NSObject>

-(void)showErrorViewWithMessage:(NSString *)message;
-(void)dismissView;


@end
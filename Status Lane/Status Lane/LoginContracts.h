//
//  LoginContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginInteractor <NSObject>

-(NSString *)requestCountryCode;
-(void)attemptLoginWithUsername:(NSString *)username andPassword:(NSString *)password;
-(void)loginCachedUser;

@end


@protocol LoginPresenter <NSObject>

-(void)showErrorViewWithErrorMessage:(NSString *)errorMessage;
-(void)login;

@end
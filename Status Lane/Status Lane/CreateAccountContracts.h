//
//  CreateAccountContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CreateAccountPresenter <NSObject>

-(void)showErrorView:(NSString *)errorMessage;
-(void)showVerifyAccount;

@end

@protocol CreateAccountInteractor <NSObject>

-(NSString*)requestCountryCode;
-(NSString *)generateVerificationCode;
-(void)sendSMSWithVerificationCode:(NSString *)number withCode:(NSString *)code;


@end
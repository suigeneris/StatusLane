//
//  CreateAccountContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CreateAccountPresenter <NSObject>

@end

@protocol CreateAccountInteractor <NSObject>

-(NSString*)requestCountryCode;
-(void)phoneNumberChanged:(NSString *)phoneNumber;
-(void)passwordChanged:(NSString *)password;
-(void)countryCodeChanged:(NSString *)cc;

-(void)attemptRegisterUser;

@end
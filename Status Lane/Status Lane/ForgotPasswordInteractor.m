//
//  ForgotPasswordInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ForgotPasswordInteractor.h"
#import "CountryCode.h"
@implementation ForgotPasswordInteractor


#pragma mark - ForgotPasswordInteractor

-(NSString *)requestCountryCode{
    
    CountryCode *code = [CountryCode sharedInstance];
    NSString *string = code.countryCode;
    return string;
}

@end

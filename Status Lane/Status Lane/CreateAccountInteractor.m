//
//  CreateAccountInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 14/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Parse/Parse.h>
#import "CreateAccountInteractor.h"
#import "CountryCode.h"

@interface CreateAccountInteractor()

@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *countryCode;

@end
@implementation CreateAccountInteractor

-(NSString *)requestCountryCode{
    
    CountryCode *code = [CountryCode sharedInstance];
    NSString *string = code.countryCode;
    _countryCode = string;
    return string;
}


#pragma mark - Create Account Interactor Delegate

-(void)passwordChanged:(NSString *)password{
    _password = password;
    
    
}
-(void)phoneNumberChanged:(NSString *)phoneNumber{
    
    _phoneNumber = phoneNumber;

}

-(void)countryCodeChanged:(NSString *)cc{
    
    _countryCode = cc;

}


-(void)attemptRegisterUser{
    
    NSString *countryCode = self.countryCode;
    NSString *phoneNumberAsUserName = [countryCode stringByAppendingString:self.phoneNumber];
    
    PFUser *user = [PFUser user];
    user.username = phoneNumberAsUserName;
    user.password = _password;
    user[@"status"] = @"single";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
    
    
        if (!error) {
            
            NSLog(@"User sign up successful");
        }
        else{
            
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            NSLog(@"This is the user info: %@", [error userInfo]);

        }
    
    }];
}





@end
//
//  LoginInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "LoginInteractor.h"
#import "CountryCode.h"
#import "Defaults.h"
#import <Parse/Parse.h>


@implementation LoginInteractor

#pragma mark -Login Interactor Delegate

-(NSString *)requestCountryCode{
    
    CountryCode *code = [CountryCode sharedInstance];
    NSString *string = code.countryCode;
    return string;
    
}

-(void)attemptLoginWithUsername:(NSString *)username andPassword:(NSString *)password{
    
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            [Defaults setPassword:password];
                                            [self.presenter login];
                                            NSLog(@"%@", user);
                                        
                                        } else {

                                            [self.presenter showErrorViewWithErrorMessage:@"Please Check Your Phone Number and Password and Try again"];
                                            NSLog(@"%@", [error userInfo]);
                                        }
                                    }];
     
}

-(void)loginCachedUser{
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        [self.presenter login];

    } else {
        
    }
}


@end

//
//  ForgotPasswordInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ForgotPasswordInteractor.h"
#import "CountryCode.h"
#import "Defaults.h"
#import <Parse/Parse.h>

@implementation ForgotPasswordInteractor


#pragma mark - ForgotPassword Interactor Delegate

-(NSString *)requestCountryCode{
    
    CountryCode *code = [CountryCode sharedInstance];
    NSString *string = code.countryCode;
    return string;
}


-(void)queryUsernameFor:(NSString *)username{
    
    
    PFQuery *query =  [PFUser query];
    [query whereKey:@"username" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if (error) {
            
            NSLog(@"%@", [error userInfo]);
            [self.presenter showErrorViewWithMessage:error.localizedDescription];
        }
        
        else{
            
            if (objects.count != 0) {
                
                //user found
                PFUser *user = [objects objectAtIndex:0];
                NSLog(@"%@", user);
                [self sendPasswordForPhoneNumber:user.username];
            }
            
            else{
                
                //no users found
                [self.presenter showErrorViewWithMessage:@"Number Not Found, Please Check and Try Again"];
            }
        }
        
        
    }];
    
}





#pragma mark - Internal Methods

-(void)showErrorMessge{
    
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.presenter showErrorViewWithMessage:@"Phone Number Not Found, Plsease check and try again"];
        
    });
}


-(void)sendPasswordForPhoneNumber:(NSString *)phoneNumber{
    

    NSLog(@"This is the password: %@",[Defaults password]);
    [PFCloud callFunctionInBackground:@"resetPassword"
                       withParameters:@{ @"number" : phoneNumber,
                                         @"password" : [Defaults password]}
                                block:^(id object, NSError *error) {
                                    
                                    
                                    if (!error) {
                                        
                                        NSLog(@"%@", object);
                                        [self.presenter dismissView];
                                    }
                                    
                                    else{
                                        
                                        NSLog(@"%@", error.localizedDescription);
                                        [self.presenter showErrorViewWithMessage:error.localizedDescription];
                                    }
                                }];
    
}















@end

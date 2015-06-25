//
//  VerifyAccountInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 21/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "VerifyAccountInteractor.h"
#import <Parse/Parse.h>
#import "Defaults.h"

@interface VerifyAccountInteractor()


@end

@implementation VerifyAccountInteractor


-(NSString *)generateVerificationCode{
    
    uint64_t verificationCode = arc4random_uniform(100000);
    NSNumber* n = [NSNumber numberWithUnsignedLongLong:verificationCode];
    
    return [n stringValue];
    
}


#pragma mark - Verify Account Interactor Delegate

-(NSString *)resendVerificationCodeToNumber:(NSString *)number{
    
    NSString *newCode = [self generateVerificationCode];
                [PFCloud callFunctionInBackground:@"verifyNumber"
                                   withParameters:@{ @"number" : number,
                                                     @"verificationCode" : newCode}
                                            block:^(id object, NSError *error) {
    
    
                                                if (!error) {
                                                    
                                                    [self.presenter hideActivityView];
                                                    NSLog(@"%@", object);
                                                }
    
                                                else{
                                                    
                                                    [self.presenter hideActivityView];
                                                    NSLog(@"%@", error.localizedDescription);
                                                    [self.presenter showErrorViewWithMessage:error.localizedDescription];
    
                                                }
                                            }];
    [self.presenter showActivityView];
    return newCode;
    
}


-(void)attemptRegisterUserWithUsername:(NSString *)username andPassword:(NSString *)password{

    [Defaults setPassword:password];
    [Defaults setStatus:@"SINGLE"];

    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user[@"status"] = @"SINGLE";
    user[@"fullName"] = @"Full Name";
    user[@"gender"] = @"Gender not set";


    
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
    
    
            if (!error) {
                
                [self.presenter hideActivityView];
                [self.presenter createAccountSuccessfull];
            }
            else{
    
                [self.presenter hideActivityView];
                NSString *errorString = [error userInfo][@"error"];
                [self.presenter showErrorViewWithMessage:errorString];

    
            }
        
        }];
    [self.presenter showActivityView];

    
}








@end

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
    //            [PFCloud callFunctionInBackground:@"verifyNumber"
    //                               withParameters:@{ @"number" : number,
    //                                                 @"verificationCode" : newCode}
    //                                        block:^(id object, NSError *error) {
    //
    //
    //                                            if (!error) {
    
    //                                                [Defaults setPassword:password];
    //                                                NSLog(@"%@", object);
    //                                            }
    //
    //                                            else{
    //
    //                                                NSLog(@"%@", error.localizedDescription);
    //                                                [self.presenter showErrorViewWithMessage:error.localizedDescription];
    //
    //                                            }
    //                                        }];
    
    return newCode;
    
}


-(void)attemptRegisterUserWithUsername:(NSString *)username andPassword:(NSString *)password{

    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user[@"status"] = @"SINGLE";
    
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
    
    
            if (!error) {
    
                [self.presenter createAccountSuccessfull];
            }
            else{
    
                NSString *errorString = [error userInfo][@"error"];
                [self.presenter showErrorViewWithMessage:errorString];

    
            }
        
        }];
    
}








@end

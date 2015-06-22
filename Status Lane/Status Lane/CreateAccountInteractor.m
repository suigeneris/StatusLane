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



@end
@implementation CreateAccountInteractor

-(NSString *)requestCountryCode{
    
    CountryCode *code = [CountryCode sharedInstance];
    NSString *string = code.countryCode;
    return string;
}


#pragma mark - Create Account Interactor Delegate

-(NSString *)generateVerificationCode{
    
    uint64_t verificationCode = arc4random_uniform(100000);
    NSNumber* n = [NSNumber numberWithUnsignedLongLong:verificationCode];

    return [n stringValue];

}

-(void)sendSMSWithVerificationCode:(NSString *)number withCode:(NSString *)code{
    
        [PFCloud callFunctionInBackground:@"verifyNumber"
                           withParameters:@{ @"number" : number,
                                             @"verificationCode" : code}
                                    block:^(id object, NSError *error) {
    
    
                                        if (!error) {
    
                                            NSLog(@"%@", object);

                                            [self.presenter showVerifyAccount];
                                        }
    
                                        else{
    
                                            NSLog(@"%@", error.localizedDescription);
                                            [self.presenter showErrorView:error.localizedDescription];
                                        }
                                    }];
    
}






@end
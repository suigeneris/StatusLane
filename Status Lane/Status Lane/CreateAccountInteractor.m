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
                                            
                                            [self.presenter hideActivityView];
                                            NSLog(@"%@", object);

                                            [self.presenter showVerifyAccount];
                                        }
    
                                        else{
                                            
                                            [self.presenter hideActivityView];
                                            NSLog(@"%@", error.localizedDescription);
                                            [self.presenter showErrorView:error.localizedDescription];
                                        }
                                    }];
    
    [self.presenter showActivityView];

    
}

-(void)queryParseForUsernmae:(NSString *)username andCode:(NSString *)code{
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        if (error) {
            
            [self.presenter hideActivityView];
            [self.presenter showErrorView:error.localizedDescription];
            
        }
        
        else{
            
            [self.presenter hideActivityView];

            if (array.count == 0) {
                
                [self sendSMSWithVerificationCode:username withCode:code];
            }
            
            else{
                
                [self.presenter showErrorView:@"A User With that Number Already Exists"];
            }
        }
    
    }];
    [self.presenter showActivityView];

    
}





















@end






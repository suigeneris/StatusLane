//
//  CreateAccountInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 14/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "CreateAccountInteractor.h"
#import "CountryCode.h"
#import "NetworkManager.h"
#import "NSString+StatusLane.h"

@interface CreateAccountInteractor()

@property (nonatomic, strong) id<NetworkProvider> networkProvider;


@end

@implementation CreateAccountInteractor

-(NSString *)requestCountryCode{
    
    CountryCode *code = [CountryCode sharedInstance];
    NSString *string = code.countryCode;
    return string;
}

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        _networkProvider = [NetworkManager new];
    }
    return _networkProvider;
}


#pragma mark - Create Account Interactor Delegate

-(NSString *)generateVerificationCode{
    
    uint64_t verificationCode = arc4random_uniform(100000);
    NSNumber* n = [NSNumber numberWithUnsignedLongLong:verificationCode];

    return [n stringValue];

}

-(void)sendSMSWithVerificationCode:(NSString *)number withCode:(NSString *)code{
    
    NSString *E164 = [[NSString allFormatsForPhoneNumber:number] objectForKey:@"E164"];
    [self.networkProvider sendSMSWithVerificationCode:E164
                                             withCode:code
                                              success:^(id responseObject) {
                                                  
                                                  NSLog(@"This is the response %@", responseObject);
                                                  [self.presenter hideActivityView];
                                                  [self.presenter showVerifyAccount];
                                                  
                                              } failure:^(NSError *error) {
                                                  
                                                  [self.presenter hideActivityView];
                                                  [self.presenter showErrorView:error.localizedDescription];
                                                  
                                              }];
    [self.presenter showActivityView];

}


-(void)queryParseForUsernmae:(NSString *)username andCode:(NSString *)code{
    
    NSString *E164 = [[NSString allFormatsForPhoneNumber:username] objectForKey:@"E164"];
    [self.networkProvider searchDatabaseForUsername:E164
                                            andCode:code
                                            success:^(id responseObject) {
                                                
                                                [self.presenter hideActivityView];
                                                NSArray *array = responseObject;
                                                if (array.count == 0) {
                                                    
                                                    [self sendSMSWithVerificationCode:E164 withCode:code];
                                                }
                                                
                                                else{
                                                    
                                                    [self.presenter showErrorView:@"A User With that Number Already Exists"];
                                                }
                                                
                                            } failure:^(NSError *error) {
                                                
                                                [self.presenter hideActivityView];
                                                [self.presenter showErrorView:error.localizedDescription];
                                            }];
    [self.presenter showActivityView];
    
    
}





















@end






//
//  VerifyAccountInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 21/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "VerifyAccountInteractor.h"
#import "Defaults.h"
#import "NetworkManager.h"
#import "PushNotificationManager.h"


@interface VerifyAccountInteractor()

@property (nonatomic, strong) id <NetworkProvider> networkProvider;
@property (nonatomic, strong) id <PushNotificationProvider> pushNotificationProvider;

@end

@implementation VerifyAccountInteractor

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        
        _networkProvider = [NetworkManager new];
    }
    return _networkProvider;
}

-(id<PushNotificationProvider>)pushNotificationProvider{
    
    if (!_pushNotificationProvider) {
        
        _pushNotificationProvider = [PushNotificationManager new];
    }
    return _pushNotificationProvider;
}

-(NSString *)generateVerificationCode{
    
    uint64_t verificationCode = arc4random_uniform(100000);
    NSNumber* n = [NSNumber numberWithUnsignedLongLong:verificationCode];
    return [n stringValue];
    
}


#pragma mark - Verify Account Interactor Delegate

-(NSString *)resendVerificationCodeToNumber:(NSString *)number{
    
    NSString *newCode = [self generateVerificationCode];
    [self.networkProvider resendVerificationCodeToNumber:number
                                                withCode:newCode
                                                 success:^(id responseObject) {
                                                     
                                                     [self.presenter hideActivityView];
                                                     NSLog(@"%@", responseObject);
                                                     
                                                 } failure:^(NSError *error) {
                                                     
                                                     [self.presenter hideActivityView];
                                                     NSLog(@"%@", error.localizedDescription);
                                                     [self.presenter showErrorViewWithMessage:error.localizedDescription];
                                                 }];
    
    [self.presenter showActivityView];
    return newCode;
    
}


-(void)attemptRegisterUserWithUsername:(NSString *)username andPassword:(NSString *)password{

    [Defaults setPassword:password];
    [Defaults setStatus:@"SINGLE"];
    
    [self.networkProvider attemptRegistrationWithUsername:username
                                              andPassword:password
                                                  success:^(id responseObject) {
                                                      
                                                      [self.presenter hideActivityView];
                                                      
                                                      [self subscriibeToPushNotificationChannel];
                                                      [self.presenter createAccountSuccessfull];

                                                      
                                                  } failure:^(NSError *error) {
                                                      
                                                      [self.presenter hideActivityView];
                                                      NSString *errorString = [error userInfo][@"error"];
                                                      [self.presenter showErrorViewWithMessage:errorString];
                                                      
                                                  }];

    [self.presenter showActivityView];

    
}


-(void)subscriibeToPushNotificationChannel{
    
    [self.pushNotificationProvider subcribeToReciveChannelWithSuccess:^(id responseObject) {
        
        
    } andFailure:^(NSError *error) {
        
        
    }];
}







@end

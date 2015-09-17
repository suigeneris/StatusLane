//
//  VerifyAccountInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 21/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "VerifyAccountInteractor.h"
#import "Defaults.h"
#import "NSString+StatusLane.h"
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

-(void)queryParseForAnonymousUser:(NSString *)username andPasswordIfAnonymousUserIsFound:(NSString *)password {
    
    NSDictionary *dictionary = [NSString allFormatsForPhoneNumber:username];
    
    NSArray *array = @[[dictionary objectForKey:@"E164"],
                       [dictionary objectForKey:@"National"]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"AnonymousUser"];
    [query whereKey:@"username" containedIn:array];
    [query includeKey:@"partner"];

    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                             
                                             [self.presenter hideActivityView];
                                             NSArray *responseArray = responseObject;
                                             if (responseArray.count == 1) {
                                                 
                                                 PFObject *anonymousUser = [responseArray objectAtIndex:0];
                                                 PFUser *user = [PFUser user];
                                                 user.username = username;
                                                 user.password = password;
                                                 user[@"fullName"] = anonymousUser[@"fullName"];
                                                 user[@"status"] = anonymousUser[@"status"];
                                                 if (![anonymousUser[@"status"] isEqualToString:@"SINGLE"]) {
                                                     user[@"partner"] = anonymousUser[@"partner"];

                                                 }
                                                 [self attemptRegisterUserWithUser:user];
                                                 [anonymousUser deleteInBackground];
                                             }
                                             else if (responseArray.count == 0){
                                                 
                                                 PFUser *user = [PFUser user];
                                                 user.username = username;
                                                 user.password = password;
                                                 user[@"status"] = @"SINGLE";
                                                 user[@"fullName"] = @"Full Name";
                                                 user[@"gender"] = @"Gender not set";
                                                 [self attemptRegisterUserWithUser:user];
                                             }
                                             
                                         } failure:^(NSError *error) {
                                             
                                             [self.presenter hideActivityView];
                                             [self.presenter showErrorViewWithMessage:error.localizedDescription];
                                         }];
    
    [self.presenter showActivityView];
}



-(void)attemptRegisterUserWithUser:(PFUser *)user{

    [self.networkProvider attemptRegistrationWithPFUser:user
                                                success:^(id responseObject) {
                                                    
                                                    [self.presenter hideActivityView];
                                                    
                                                    if (user[@"fullName"]) {
                                                        [Defaults setFullName:user[@"fullName"]];
                                                    }
                                                    if (user[@"gender"]) {
                                                        [Defaults setSex:user[@"gender"]];
                                                    }
                                                    if (user[@"partner"]) {
                                                        
                                                        PFUser *partnerForAnonymousUser = [user[@"partner"] objectAtIndex:0];
                                                        [Defaults setPartnerFullName:partnerForAnonymousUser[@"fullName"]];
                                                    }
                                                    
                                                    [Defaults setUsername:user.username];
                                                    [Defaults setPassword:user.password];
                                                    [Defaults setStatus:user[@"status"]];
                                                    
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

//
//  NetworkManager.m
//  Status Lane
//
//  Created by Jonathan Aguele on 22/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "NetworkManager.h"

#define kBaseURL @"https://www.bulksms.co.uk/eapi/"
#define kSendSMS @"submission/send_sms/2/2.0"
#define kAuthentication @"?username=Jonathan_Aguele&password=4evayoung&"
#define kMessage @"message=%@"

@interface NetworkManager () <NSURLSessionDelegate>

@property (nonatomic) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic) NSURLSession *urlSession;


@end

@implementation NetworkManager


#pragma mark - Login Account Feature

-(void)loginWithUsername:(NSString *)username
             andPassword:(NSString *)password
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock{
    
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        if (error) {
                                            
                                            failureBlock(error);
                                            
                                        } else {
                                            
                                            successBlock(user);
                                        }
                                    }];
    
    
    
    
}

#pragma mark - Reset Password Feature

-(void)resetPasswordForUserWithEmail:(NSString *)email
                            succcess:(SuccessBlock)successBlock
                             failure:(FailureBlock)failureBlock{
    
    [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL sucesss, NSError *error){
    
        if (error) {
            failureBlock(error);
        }
        
        else{
            successBlock(nil);
        }
        
    }];
    
    
}
#pragma mark - Create Account Feature

-(void)sendSMSWithVerificationCode:(NSString *)number
                          withCode:(NSString *)code
                           success:(SuccessBlock)successBlock
                           failure:(FailureBlock)failureBlock{
    
//    [PFCloud callFunctionInBackground:@"verifyNumber"
//                       withParameters:@{ @"number" : number,
//                                         @"verificationCode" : code}
//     
//                                block:^(id object, NSError *error) {
//                                    
//                                    
//                                    if (!error) {
//                                        
//                                        successBlock(object);
//                                    }
//                                    
//                                    else{
//                                        
//                                        failureBlock(error);
//                                    }
//                                }];
    
    NSString *urlString = [NSString stringWithFormat:@"https://www.bulksms.co.uk/eapi/submission/send_sms/2/2.0?username=Jonathan_Aguele&password=4evayoung&message=%@&msisdn=%@", code, number];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:request
                                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                            
                                                            if(error){
                                                                
                                                                failureBlock(error);
                                                            }
                                                            
                                                            else{
                                                                
                                                                successBlock(data);
                                                            }
                                                            
                                                        }];
    [dataTask resume];
    
}

-(void)searchDatabaseForUsername:(NSString *)username
                         andCode:(NSString *)code
                         success:(SuccessBlock)successBlock
                         failure:(FailureBlock)failureBlock{
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        if (error) {
            
            failureBlock(error);
        }
        
        else{
            
            successBlock(array);
        }
        
    }];
    
}

#pragma mark - Verify Password Feature

-(void)resendVerificationCodeToNumber:(NSString *)number
                              withCode:(NSString *)newCode
                               success:(SuccessBlock)successBlock
                               failure:(FailureBlock)failureBlock{
    
    [PFCloud callFunctionInBackground:@"verifyNumber"
                       withParameters:@{ @"number" : number,
                                         @"verificationCode" : newCode}
     
                                block:^(id object, NSError *error) {
                                    
                                    if (error) {
                                        
                                        failureBlock(error);
                                    }
                                    
                                    else{
                                        
                                        successBlock(object);
                                    }
                                }];
}

-(void)attemptRegistrationWithPFUser:(PFUser *)user
                             success:(SuccessBlock)suceessBlock
                             failure:(FailureBlock)failureBlock{

    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        
        if (error) {
            
            failureBlock(error);
            
        }
        else{
            
            suceessBlock(nil);
            
            
        }
        
    }];
    
}


#pragma mark - User Interactor


-(void)fetchCurrentUserIfNeededWithSuccesss:(SuccessBlock)success
                                 andFailure:(FailureBlock)failure{
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeededInBackgroundWithBlock:^(NSObject *object, NSError *error){
        
        if (error) {
            failure(error);
        }
        
        else{
            
            success(object);
        }
    }];
}


-(void)fetchCurrentUserWithSuccesss:(SuccessBlock)success
                         andFailure:(FailureBlock)failure{
    
    PFUser *user = [PFUser currentUser];
    [user fetchInBackgroundWithBlock:^(NSObject *object, NSError *error){
        
        if (error) {
            failure(error);
        }
        
        else{
            
            success(object);
        }
    }];
}


#pragma mark - Annoymous User Interactor

-(void)queryDatabaseWithQuery:(PFQuery *)query
                      success:(SuccessBlock)successBlock
                      failure:(FailureBlock)failureBlock{
    

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        if (error) {
            
            failureBlock(error);
        }
        
        else{
            
            successBlock(array);
            
        }
        
    }];
    
}

-(void)saveWithPFObject:(PFObject *)object
                success:(SuccessBlock)sucessBlock
                failure:(FailureBlock)failureBlock{

    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        if (error) {
            
            failureBlock(error);
        }
        
        else{
            
            NSNumber *number = [NSNumber numberWithBool:succeeded];
            sucessBlock(number);
        }
    }];
    
    
}


#pragma mark - Pending Notification Feature

-(void)deleteRowWithObject:(PFObject *)object
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock{
    
    
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
    
        if (error) {
            
            failureBlock(error);
        }
        
        else{
            
            NSNumber *number = [NSNumber numberWithBool:succeeded];
            successBlock(number);
        }
    }];
    
}


#pragma mark - Downloading Image Data

-(void)downloadDataFromFile:(PFFile *)file
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock{
    
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        
        if (error) {
            
            failureBlock(error);
        }
        
        else{
            
            successBlock(data);
        }
        
    }];
}

#pragma mark - Delete Accont

-(void)deleteUserAccountWithAccount:(PFUser *)user
                            success:(SuccessBlock)successBlock
                            failure:(FailureBlock)failureBlock{
    
    
    [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        if (error) {
        
            failureBlock(error);
        }
        else{
            
            successBlock(nil);
        }
    }];
}


#pragma mark - NSURLSession

-(NSURLSessionConfiguration *)sessionConfiguration{
    
    if (!_sessionConfiguration) {
        _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [_sessionConfiguration setHTTPAdditionalHeaders:@{@"Content-Type": @"application/x-www-form-urlencoded",
                                                          @"Accept": @"text/plain"}];
        [_sessionConfiguration setTimeoutIntervalForRequest:10];
    }
    
    return _sessionConfiguration;
}

-(NSURLSession *)urlSession{
    
    if (!_urlSession) {
        
        _urlSession = [NSURLSession sessionWithConfiguration:[self sessionConfiguration]];
        
    }
    
    return _urlSession;
}


-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge.protectionSpace.host isEqualToString:@""]) {
            
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    }
}
@end























//
//  NetworkProvider.h
//  Status Lane
//
//  Created by Jonathan Aguele on 22/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSError *error);


@protocol NetworkProvider <NSObject>

#pragma mark - Login Account Feature

-(void)loginWithUsername:(NSString *)username
             andPassword:(NSString *)password
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;



#pragma mark - Create Account Feature

-(void)sendSMSWithVerificationCode:(NSString *)number
                          withCode:(NSString *)code
                           success:(SuccessBlock)successBlock
                           failure:(FailureBlock)failureBlock;

-(void)searchDatabaseForUsername:(NSString *)username
                         andCode:(NSString *)code
                         success:(SuccessBlock)successBlock
                         failure:(FailureBlock)failureBlock;


#pragma mark - Verify Password Feature

-(void)resendVerificationCodeToNumber:(NSString *)number
                             withCode:(NSString *)newCode
                              success:(SuccessBlock)successBlock
                              failure:(FailureBlock)failure;

-(void)attemptRegistrationWithUsername:(NSString *)username
                           andPassword:(NSString *)password
                               success:(SuccessBlock)suceessBlock
                               failure:(FailureBlock)failureBlock;

#pragma mark - User Interactor

-(void)fetchCurrentUserWithSuccesss:(SuccessBlock)success
                         andFailure:(FailureBlock)failure;

#pragma mark - Annoymous User Interactor

-(void)queryDatabaseWithQuery:(PFQuery *)query
                      success:(SuccessBlock)successBlock
                      failure:(FailureBlock)failureBlock;

-(void)saveWithPFObject:(PFObject *)object
                success:(SuccessBlock)sucessBlock
                failure:(FailureBlock)failureBlock;

#pragma mark - Pending Notification Feature

-(void)deleteRowWithObject:(PFObject *)object
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock;

@end



























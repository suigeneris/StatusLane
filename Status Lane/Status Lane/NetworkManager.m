//
//  NetworkManager.m
//  Status Lane
//
//  Created by Jonathan Aguele on 22/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "NetworkManager.h"
//#import <Parse/Parse.h>

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
#pragma mark - Create Account Feature

-(void)sendSMSWithVerificationCode:(NSString *)number
                          withCode:(NSString *)code
                           success:(SuccessBlock)successBlock
                           failure:(FailureBlock)failureBlock{
    
    
    [PFCloud callFunctionInBackground:@"verifyNumber"
                       withParameters:@{ @"number" : number,
                                         @"verificationCode" : code}
     
                                block:^(id object, NSError *error) {
                                    
                                    
                                    if (!error) {
                                        
                                        successBlock(object);
                                    }
                                    
                                    else{
                                        
                                        failureBlock(error);
                                    }
                                }];
    

    
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

-(void)attemptRegistrationWithUsername:(NSString *)username
                           andPassword:(NSString *)password
                               success:(SuccessBlock)suceessBlock
                               failure:(FailureBlock)failureBlock{
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user[@"status"] = @"SINGLE";
    user[@"fullName"] = @"Full Name";
    user[@"gender"] = @"Gender not set";
    
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

-(void)searchForUserWithUsername:(NSString *)username
                     andFullName:(NSString *)fullName
                         success:(SuccessBlock)successBlock
                         failure:(FailureBlock)failureBlock{
    
    
}


#pragma mark - Annoymous User Interactor

-(void)searchAnonymousUserWithUsername:(NSString *)username
                           andFullName:(NSString *)fullName
                               success:(SuccessBlock)successBlock
                               failure:(FailureBlock)failureBlock{
    
    PFQuery *query = [PFQuery queryWithClassName:@"AnonymousUser"];
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

-(void)createRelationshipWithAnnoymousUser:(PFObject *)anonymousUser
                                   success:(SuccessBlock)sucessBlock
                                   failure:(FailureBlock)failureBlock{
    
    
}

-(void)setNewPartner:(PFObject *)newPartner
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    
    
}
















@end























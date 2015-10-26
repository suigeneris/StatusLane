//
//  NetworkManager.m
//  Status Lane
//
//  Created by Jonathan Aguele on 22/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "NetworkManager.h"

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

@end























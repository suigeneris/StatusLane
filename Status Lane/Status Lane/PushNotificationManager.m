//
//  PushNotificationManager.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PushNotificationManager.h"

@implementation PushNotificationManager

-(void)subcribeToReciveChannelWithSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure{
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *objectID = [currentUser objectId];
    
    [PFPush subscribeToChannelInBackground:objectID
                                     block:^(BOOL succeeded, NSError * __nullable error) {
                                         
                                         if (error) {
                                             failure(error);
                                         }
                                         else{
                                             
                                             NSNumber *number = [NSNumber numberWithBool:succeeded];
                                             success(number);
                                         }
                                         
                                     }];
    
}


-(void)sendPushNotificationWithPush:(PFPush *)push
                        withSuccess:(SuccessBlock)success
                         andFailure:(FailureBlock)failure{
    
    

    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * __nullable error) {
        
        if (error) {
            
            failure(error);
        }
        
        else{
            
            NSNumber *number = [NSNumber numberWithBool:succeeded];
            success(number);
        }
    }];
}

-(void)callCloudFuntionWithName:(NSString *)name
                     parameters:(NSDictionary *)parameters
                        success:(SuccessBlock)successBlock
                     andFailure:(FailureBlock)failureBlock{
    
    [PFCloud callFunctionInBackground:name
                       withParameters:parameters
                                block:^(id object, NSError *error) {
                                    
                                    if (error) {
                                        
                                        failureBlock(error);
                                    }
                                    
                                    else{
                                        
                                        successBlock(object);
                                    }
                                }];
    
}
@end

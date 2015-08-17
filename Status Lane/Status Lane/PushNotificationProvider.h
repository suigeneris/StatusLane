//
//  PushNotificationProvider.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSError *error);

@protocol PushNotificationProvider <NSObject>

-(void)subcribeToReciveChannelWithSuccess:(SuccessBlock)success
                               andFailure:(FailureBlock)failure;

-(void)sendPushNotificationWithPush:(PFPush *)push
                           withSuccess:(SuccessBlock)success
                            andFailure:(FailureBlock)failure;

#pragma mark - Cloud Function

-(void)callCloudFuntionWithName:(NSString *)name
                     parameters:(NSDictionary *)parameters
                        success:(SuccessBlock)successBlock
                     andFailure:(FailureBlock)failureBlock;
@end

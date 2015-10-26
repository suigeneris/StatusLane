//
//  UserProfileInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 12/10/2015.
//  Copyright © 2015 Sui Generis Innovations. All rights reserved.
//

#import "UserProfileInteractor.h"
#import "PushNotificationManager.h"
#import "NSString+StatusLane.h"

@interface UserProfileInteractor ()

@property (nonatomic, strong) id<PushNotificationProvider> pushNotificationProvider;
@end

@implementation UserProfileInteractor


-(id<PushNotificationProvider>)pushNotificationProvider{
    
    if (!_pushNotificationProvider) {
        
        _pushNotificationProvider = [PushNotificationManager new];
    }
    return _pushNotificationProvider;
}


#pragma mark - Interactor Delegate Methods

- (void)sendStatusRequestToUser:(PFUser *)user{
    
    NSString *channel = [NSString verifyObjectId:[user objectId]];
    
    NSDictionary *dict = @{@"alert" : @"Wants To View Your Status",
                           @"objectId" : [[PFUser currentUser] objectId],
                           @"fullName" : [[PFUser currentUser] objectForKey:@"fullName"],
                           @"badge" : @"Increment",
                           @"channel" : channel,
                           @"needsResponse" : [NSNumber numberWithBool:YES]
                           };
    
    
    [self.pushNotificationProvider callCloudFuntionWithName:@"sendPushNotification"
                                                 parameters:dict
                                                    success:^(id responseObject) {
                                                       
                                                        [self.presenter stopAnimating];
                                                        [self.presenter showResponseViewWithMessage:[NSString stringWithFormat:@"Your Request Has Been Sent Successfully, Pending Approval from %@", user[@"fullName"]]
                                                                                           andTitle:@"Yayyyy!"];
                                                        
                                                    } andFailure:^(NSError *error) {
                                                        
                                                        [self.presenter stopAnimating];
                                                        [self.presenter showResponseViewWithMessage:error.localizedDescription
                                                                                           andTitle:@"OOOOPs!"];
                                                        
                                                    }];
    
    [self.presenter startAnimating];
}

-(void)sendStatusHistoryRequestToUser:(PFUser *)user{
    
    NSString *channel = [NSString verifyObjectId:[user objectId]];
    
    NSDictionary *dict = @{@"alert" : @"Wants To View Your Status Histroy",
                           @"objectId" : [[PFUser currentUser] objectId],
                           @"fullName" : [[PFUser currentUser] objectForKey:@"fullName"],
                           @"badge" : @"Increment",
                           @"channel" : channel,
                           @"needsResponse" : [NSNumber numberWithBool:YES]
                           };
    
    [self.pushNotificationProvider callCloudFuntionWithName:@"sendPushNotification"
                                                 parameters:dict
                                                    success:^(id responseObject) {
                                                        
                                                        [self.presenter stopAnimating];
                                                        [self.presenter showResponseViewWithMessage:[NSString stringWithFormat:@"Your Request Has Been Sent Successfully, Pending Approval from %@", user[@"fullName"]]
                                                                                           andTitle:@"Yayyyy!"];
                                                        
                                                    } andFailure:^(NSError *error) {
                                                        
                                                        [self.presenter stopAnimating];
                                                        [self.presenter showResponseViewWithMessage:error.localizedDescription
                                                                                           andTitle:@"OOOOPs!"];
                                                        
                                                        
                                                    }];
    
    [self.presenter startAnimating];

    
}




@end

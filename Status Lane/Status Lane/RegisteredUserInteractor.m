//
//  RegisteredUserInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 28/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "RegisteredUserInteractor.h"
#import "ChoosePartnerPresenter.h"
#import "NetworkManager.h"
#import "PushNotificationManager.h"
#import "Defaults.h"

@interface RegisteredUserInteractor() {
    
    NSString *partnerStatus;
    NSString *partnerName;
}

@property (nonatomic) id <PushNotificationProvider> pushNotificationProvider;
@property (nonatomic) id <NetworkProvider> networkProvider;

@end

@implementation RegisteredUserInteractor

-(id<PushNotificationProvider>)pushNotificationProvider{
    
    if (!_pushNotificationProvider) {
        
        _pushNotificationProvider = [PushNotificationManager new];
        
    }
    return _pushNotificationProvider;
}

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        _networkProvider = [NetworkManager new];
        
    }
    
    return _networkProvider;
}

-(void)determineRelationshipStatus:(NSString *)status ForUser:(PFUser *)user{
    
    partnerStatus = status;
    partnerName = user[@"fullName"];
    NSLog(@"This is the status %@", partnerStatus);
    
    if (user[@"partner"]) {
        
        [self.presenter stopAnimatingActivitiyView];
        [self.presenter showErrorView:[NSString stringWithFormat:@"This User has a %@ status with someone else", user[@"status"]]];
    }
    else{
        
//        if ([self determinePartnerOfUser:user] && [[Defaults status] isEqualToString:status]) {
//            
//            NSLog(@"trying to set same user with same status");
//            [self.presenter stopAnimatingActivitiyView];
//            [self.presenter dismissView];
//        }
//        
//        else{
//            
//            if ([self determinePartnerOfUser:user]) {
//                
//                NSString *string = [NSString stringWithFormat:@"Your partner has updated you guys status to %@", status];
//                [self sendRelationshipRequestToUser:user withRequestMessage:string];
//            }
//            
//            else{
        
                [self sendRelationshipRequestToUser:user withRequestMessage:@"Sent You a Partner Request"];
                
//            }

//        }
    }
    
}


-(void)sendRelationshipRequestToUser:(PFUser *)user withRequestMessage:(NSString *)requestMessage{
    
    NSString *channel = [user objectId];
    NSDictionary *dictionary = @{
                                 @"alert" : requestMessage,
                                 @"badge" : @"Increment",
                                 @"channel" : channel,
                                 @"objectId" : [[PFUser currentUser] objectId],
                                 @"fullName" : [[PFUser currentUser] objectForKey:@"fullName"]
                                 };
    
    [self.pushNotificationProvider callCloudFuntionWithName:@"sendPushNotification"
                                                 parameters:dictionary
                                                    success:^(id responseObject) {
                                                        
                                                        [self setRelationshipStatusWithUser:user];
                                                        
                                                    } andFailure:^(NSError *error) {
                                                        
                                                        [self.presenter stopAnimatingActivitiyView];
                                                        [self.presenter showErrorView:error.localizedDescription];
                                                        
                                                    }];
    
    
}

-(void)setRelationshipStatusWithUser:(PFUser *)user{
    

    PFUser *currentUser = [PFUser currentUser];
    

            currentUser[@"status"] = partnerStatus;
            NSLog(@"Is this called");

            NSArray *partnerArray = @[user];
            [currentUser setObject:partnerArray forKey:@"partner"];
            
            [self.networkProvider saveWithPFObject:currentUser
                                           success:^(id responseObject) {
                                               
                                               
                                               [Defaults setPartnerFullName:partnerName];
                                               [Defaults setStatus:partnerStatus];
                                               [self.presenter stopAnimatingActivitiyView];
                                               [self.presenter dismissView];
                                               
                                           } failure:^(NSError *error) {
                                               
                                               [self.presenter stopAnimatingActivitiyView];
                                               [self.presenter showErrorView:error.localizedDescription];
                                           }];


    
    
    
    
}



-(BOOL)determinePartnerOfUser:(PFUser *)user{
    
    
    //current user
    PFUser *currentUser = [PFUser currentUser];
    NSArray *array = currentUser[@"partner"];
    PFUser *currentUserPartner = [array objectAtIndex:0];
    NSString *currentUserPartnerObjectId = [currentUserPartner objectId];
    
    //new user
    NSString *newUserObjectId = [user objectId];
    
    if ([currentUserPartnerObjectId isEqualToString:newUserObjectId]) {
        return YES;
    }
    else{
        return NO;
    }



}
@end












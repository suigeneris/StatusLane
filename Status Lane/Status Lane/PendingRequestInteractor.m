//
//  PendingRequestInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PendingRequestInteractor.h"
#import "PendingRequestsDataSource.h"
#import "NSString+StatusLane.h"
#import "NetworkManager.h"
#import "PushNotificationManager.h"
#import "Defaults.h"

@interface PendingRequestInteractor ()

@property (nonatomic, strong) id<UITableViewDataSource> datasource;
@property (nonatomic, strong) PendingRequestsDataSource *pendingRequestsDatasource;
@property (nonatomic, strong) id <NetworkProvider> networkProvider;
@property (nonatomic, strong) id <PushNotificationProvider> pushNotificationProvider;
@property (nonatomic, strong) NSMutableArray *arrayOfNotifications;
@property (nonatomic, strong) NSArray *arrayOfNotificationSenders;

@end

@implementation PendingRequestInteractor


-(id<UITableViewDataSource>)dataSource{
    
    if (!_datasource) {
        
        _datasource = self.pendingRequestsDatasource;
    }
    
    return _datasource;
}

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

-(PendingRequestsDataSource *)pendingRequestsDatasource{
    
    if (!_pendingRequestsDatasource) {
        
        _pendingRequestsDatasource = [PendingRequestsDataSource new];
        _pendingRequestsDatasource.interactor = self;
        
    }
    
    return _pendingRequestsDatasource;
}

#pragma mark - Interactor delegate methods


-(void)retrieveArrayOfNotificationsForUser{
    
    PFQuery *query = [PFQuery queryWithClassName:@"NotificationObject"];
    [query whereKey:@"receiverObjectId" equalTo:[NSString verifyObjectId:[PFUser currentUser].objectId]];
    [query orderByDescending:@"createdAt"];
    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             NSMutableArray *arrayWithNotificationObjects = responseObject;
                                             [self getNotificationSendersFromArray:arrayWithNotificationObjects];
                                             self.arrayOfNotifications = [self pourNotificationObjectsIntoMutableDictionary:arrayWithNotificationObjects];
                                             [self.presenter reloadDatasource];

                                         } failure:^(NSError *error) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             NSLog(@"This is the error %@", error.localizedDescription);
                                         }];
    
    [self.presenter startAnimatingActivityView];

}

-(void)rejectNotificationForUserAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.arrayOfNotifications objectAtIndex:indexPath.row];
    NSString *objectId = [dict objectForKey:@"objectId"];
    
    PFObject *notificationObject = [PFObject objectWithoutDataWithClassName:@"NotificationObject"
                                                                   objectId:objectId];
    
    [self deleteRowWithNotificationObject:notificationObject withIndexPath:indexPath withResponse:NO];
    
}

-(void)acceptNotificationForUserAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.arrayOfNotifications objectAtIndex:indexPath.row];
    NSString *objectId = [dict objectForKey:@"objectId"];
    
    PFObject *notificationObject = [PFObject objectWithoutDataWithClassName:@"NotificationObject"
                                                                   objectId:objectId];
    
    [self deleteRowWithNotificationObject:notificationObject withIndexPath:indexPath withResponse:YES];
}

-(void)acknowledgeNotificationForUserAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.arrayOfNotifications objectAtIndex:indexPath.row];
    NSString *objectId = [dict objectForKey:@"objectId"];
    
    PFObject *notificationObject = [PFObject objectWithoutDataWithClassName:@"NotificationObject"
                                                                   objectId:objectId];
    
        [self.networkProvider deleteRowWithObject:notificationObject
                                          success:^(id responseObject) {
                                             
                                              [self.presenter stopAnimatingActivitiyView];
                                              [self.arrayOfNotifications removeObjectAtIndex:indexPath.row];
                                              [self.presenter deleteTableViewRowWithIndexPaths:indexPath];
                                              [self updateBadgeNumber];

                                              
                                          } failure:^(NSError *error) {
                                              
                                              [self.presenter stopAnimatingActivitiyView];
                                              [self updateBadgeNumber];
                                              NSLog(@"failed with error :%@", error.localizedDescription);


                                          }];
}

-(void)getProfileForUserAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.arrayOfNotifications objectAtIndex:indexPath.row];
    NSString *senderObjectId = [dict objectForKey:@"senderObjectId"];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:senderObjectId];
    [query includeKey:@"User.partner"];
    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             PFUser *user = [responseObject objectAtIndex:0];
                                             [self.presenter showUserProfileWithUser:user];
                                             [self updateBadgeNumber];
                                             
                                         } failure:^(NSError *error) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             [self updateBadgeNumber];
                                             NSLog(@"This is the error %@", error.localizedDescription);
                                             
                                         }];
    
    [self.presenter startAnimatingActivityView];
    


}


-(void)getHistoryForUserAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.arrayOfNotifications objectAtIndex:indexPath.row];
    NSString *senderObjectId = [dict objectForKey:@"senderObjectId"];
    PFQuery *query = [PFQuery queryWithClassName:@"StatusHistory"];
    [query whereKey:@"historyId" equalTo:senderObjectId];
    [query orderByDescending:@"statusDate"];
    [query includeKey:@"StatusHistory.partnerId"];
    query.limit = 20;
    
    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             [self.presenter showUserHistoryWithHistory:responseObject];
                                             [self updateBadgeNumber];
                                             
                                         } failure:^(NSError *error) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             [self updateBadgeNumber];
                                             NSLog(@"This is the error %@", error.localizedDescription);
                                             
                                         }];
    
    [self.presenter startAnimatingActivityView];
    
}

#pragma mark - Table Delegate Methods


#pragma mark - Internal Methods

-(NSArray *)returnArrayOfNotifications{
    
    return self.arrayOfNotifications;
    
}

-(NSArray *)returnArrayOfNotificationSenders{
    
    return self.arrayOfNotificationSenders;
}

-(void)deleteRowWithNotificationObject:(PFObject *)notificationObject withIndexPath:(NSIndexPath *)indexPath withResponse:(BOOL)response{
    
    NSDictionary *dict = [self.arrayOfNotifications objectAtIndex:indexPath.row];

    [self.networkProvider deleteRowWithObject:notificationObject
                                      success:^(id responseObject) {
                                          
                                          [self.presenter stopAnimatingActivitiyView];
                                          [self.arrayOfNotifications removeObjectAtIndex:indexPath.row];
                                          [self determineReqestTypeWithDictionary:dict andResponse:response];
                                          [self.presenter deleteTableViewRowWithIndexPaths:indexPath];
                                          [self updateBadgeNumber];

                                          
                                      } failure:^(NSError *error) {
                                          
                                          [self.presenter stopAnimatingActivitiyView];
                                          NSLog(@"failed with error :%@", error.localizedDescription);
                                      }];
    
    [self.presenter startAnimatingActivityView];

    
}


-(void)determineReqestTypeWithDictionary:(NSDictionary *)dictionary andResponse:(BOOL)response{
    
    if (!response) {
        
        
        //Send Notification to to tell the user who sent the request that their request was rejected
        [self.pushNotificationProvider callCloudFuntionWithName:@"updateUserWithMasterKey"
                                                     parameters:@{@"updatingUserObjectId" : [dictionary objectForKey:@"senderObjectId"],
                                                                  @"updatingStatus" : @"SINGLE"}
                                                        success:^(id responseObject) {
                                                            
                                                            [self sendPushNotificationWithDictionary:dictionary andMessage:[self returnAlertResponseForRejectedAlertMessage:[dictionary objectForKey:@"alert"]] withNeedsResponse:NO];

                                                            
                                                        } andFailure:^(NSError *error) {
                                                            
                                                            NSLog(@"This is the error %@", error.localizedDescription);
                                                        }];
    }
    
    else {
        
        PFUser *currentUser = [PFUser currentUser];
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" equalTo:[dictionary objectForKey:@"senderObjectId"]];
        [self.networkProvider queryDatabaseWithQuery:query
                                             success:^(id responseObject) {
                                                 
                                                 PFUser *foundUser = [responseObject objectAtIndex:0];
                                                 currentUser[@"status"] = foundUser[@"status"];
                                                 NSArray *arrayWithPartner = @[foundUser];
                                                 currentUser[@"partner"] = arrayWithPartner;
                                                 [Defaults setPartnerFullName:foundUser[@"fullName"]];
                                                 
                                                 [self.networkProvider saveWithPFObject:currentUser
                                                                                success:^(id responseObject) {
                                                                                    
                                                                                    [self sendPushNotificationWithDictionary:dictionary andMessage:[self returnAlertResponseForAcceptedAlertMessage:[dictionary objectForKey:@"alert"]] withNeedsResponse:NO];
                                                                                    [self createHistoryObjectsForCurrentUser:currentUser AndPartner:foundUser];

                                                                                } failure:^(NSError *error) {
                                                                                    
                                                                                    NSLog(@"This is the error %@", error.localizedDescription);
                                                                                }];
                                                 
                                             } failure:^(NSError *error) {
                                                 
                                                 NSLog(@"This is the error %@", error.localizedDescription);
                                             }];

    }
    
}

-(void)getNotificationSendersFromArray:(NSMutableArray *)array{
    
    NSMutableArray *arrayOfObjectIdsForQueries = [NSMutableArray new];
    NSMutableArray *arrayOfQueries = [NSMutableArray new];
    
    for (PFObject *object in array) {
        
        NSString *objectId = object[@"senderObjectId"];
        if ([arrayOfObjectIdsForQueries containsObject:objectId]) {
            
        }
        else{
            
            [arrayOfObjectIdsForQueries addObject:objectId];
        }
    }
    
    for (NSString *string in arrayOfObjectIdsForQueries) {
        
        PFQuery *subQuery = [PFUser query];
        [subQuery whereKey:@"objectId" equalTo:string];
        [arrayOfQueries addObject:subQuery];
    }
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:arrayOfQueries];
    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             self.arrayOfNotificationSenders = responseObject;
                                             [self.presenter reloadDatasource];
                                             
                                             
                                         } failure:^(NSError *error) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             NSLog(@"This is the error %@", error.localizedDescription);
                                             
                                             
                                         }];
    
    [self.presenter startAnimatingActivityView];
    
    
}

-(NSMutableArray *)pourNotificationObjectsIntoMutableDictionary:(NSMutableArray *)array{
    
    NSMutableArray *finalArray = [NSMutableArray new];
    
    for (PFObject *object in array) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:object[@"senderFullName"] forKey:@"senderFullName"];
        [dict setObject:object[@"senderObjectId"] forKey:@"senderObjectId"];
        [dict setObject:object[@"receiverObjectId"] forKey:@"receiverObjectId"];
        [dict setObject:[object objectId] forKey:@"objectId"];
        [dict setObject:object[@"alert"] forKey:@"alert"];
        [dict setObject:object[@"needsResponse"] forKey:@"needsResponse"];

        [finalArray addObject:dict];
    }
    return finalArray;
}


-(void)sendPushNotificationWithDictionary:(NSDictionary *)dictionary andMessage:(NSString *)message withNeedsResponse:(BOOL)needsResponse{
    
    PFUser *currentUser = [PFUser currentUser];
    
    NSDictionary *pushDictionary = @{
                                     
                                 @"alert" : message,
                                 @"badge" : @"Increment",
                                 @"channel" : [NSString verifyObjectId:[dictionary objectForKey:@"senderObjectId"]],
                                 @"objectId" : currentUser.objectId,
                                 @"fullName" : currentUser[@"fullName"],
                                 @"needsResponse" : [NSNumber numberWithBool:needsResponse]

                                 };

    [self.pushNotificationProvider callCloudFuntionWithName:@"sendPushNotification"
                                                 parameters:pushDictionary
                                                    success:^(id responseObject) {
                                                       
                                                        [self.presenter stopAnimatingActivitiyView];
                                                        
                                                    } andFailure:^(NSError *error) {
                                                        
                                                        [self.presenter stopAnimatingActivitiyView];
                                                        NSLog(@"This is the error %@", error.localizedDescription);
                                                        
                                                    }];
}

-(void)createHistoryObjectsForCurrentUser:(PFUser *)currentUser AndPartner:(PFUser *)partner{
    
    PFObject *currentUserHistoryObject = [PFObject objectWithClassName:@"StatusHistory"];
    currentUserHistoryObject[@"historyId"] = currentUser.objectId;
    currentUserHistoryObject[@"partnerId"] = partner.objectId;
    currentUserHistoryObject[@"partnerName"] = partner[@"fullName"];
    currentUserHistoryObject[@"fullName"] = currentUser[@"fullName"];
    currentUserHistoryObject[@"statusType"] = currentUser[@"status"];
    currentUserHistoryObject[@"statusDate"] = [NSDate date];
    [currentUserHistoryObject saveInBackground];
    
    PFObject *partnerHistoryObject = [PFObject objectWithClassName:@"StatusHistory"];
    partnerHistoryObject[@"historyId"] = partner.objectId;
    partnerHistoryObject[@"partnerId"] = currentUser.objectId;
    partnerHistoryObject[@"partnerName"] = currentUser[@"fullName"];
    partnerHistoryObject[@"fullName"] = partner[@"fullName"];
    partnerHistoryObject[@"statusType"] = currentUser[@"status"];
    partnerHistoryObject[@"statusDate"] = [NSDate date];
    [partnerHistoryObject saveInBackground];
    
    
    
}
-(void)updateBadgeNumber{
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.badge = currentInstallation.badge - 1;
    [currentInstallation saveInBackground];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber - 1;

}


-(NSString *)returnAlertResponseForRejectedAlertMessage:(NSString *)alertMessage{
    
    NSString *alertResponse;
    
    if ([alertMessage isEqualToString:@"Sent You a Partner Request"]) {
        
        alertResponse = [NSString stringWithFormat:@"Did Not Approve Your Partner Request"];
    }
    
    else if ([alertMessage isEqualToString:@"Wants To View Your Status"]) {
        
        alertResponse = [NSString stringWithFormat:@"Did Not Approve Your Status Request"];
    }
    
    else if ([alertMessage isEqualToString:@"Wants To View Your Status Histroy"]) {
        
        alertResponse = [NSString stringWithFormat:@"Did Not Approve Your Status History Request"];
    }
    
    return alertResponse;
}


-(NSString *)returnAlertResponseForAcceptedAlertMessage:(NSString *)alertMessage{
    
    NSString *alertResponse;
    
    if ([alertMessage isEqualToString:@"Sent You a Partner Request"]) {
        
        alertResponse = [NSString stringWithFormat:@"Approved Your Partner Request"];
    }
    
    else if ([alertMessage isEqualToString:@"Wants To View Your Status"]) {
        
        alertResponse = [NSString stringWithFormat:@"Approved Your Status Request"];
    }
    
    else if ([alertMessage isEqualToString:@"Wants To View Your Status Histroy"]) {
        
        alertResponse = [NSString stringWithFormat:@"Approved Your Status History Request"];
    }
    
    return alertResponse;
}
@end





















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

@interface PendingRequestInteractor ()

@property (nonatomic, strong) id<UITableViewDataSource> datasource;
@property (nonatomic, strong) PendingRequestsDataSource *pendingRequestsDatasource;
@property (nonatomic, strong) id <NetworkProvider> networkProvider;
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
    [query whereKey:@"receiverObjectId" equalTo:[PFUser currentUser].objectId];
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
    
    [self.networkProvider deleteRowWithObject:notificationObject
                                      success:^(id responseObject) {
                                          
                                          [self.arrayOfNotifications removeObjectAtIndex:indexPath.row];
                                          [self.presenter deleteTableViewRowWithIndexPaths:indexPath];
                                          
                                      } failure:^(NSError *error) {
                                          
                                          NSLog(@"failed with error :%@", error.localizedDescription);
                                      }];
    
    
    
}

-(void)acceptNotificationForUserAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(NSArray *)returnArrayOfNotifications{
    
    return self.arrayOfNotifications;
    
}

-(NSArray *)returnArrayOfNotificationSenders{
    
    return self.arrayOfNotificationSenders;
}


#pragma mark - Table Delegate Methods


#pragma mark - Internal Methods

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
        [dict setObject:[object objectId] forKey:@"objectId"];
        [dict setObject:object[@"alert"] forKey:@"alert"];
        [finalArray addObject:dict];
    }
    return finalArray;
}



@end





















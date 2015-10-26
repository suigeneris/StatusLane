//
//  RelationshipHistoryInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "RelationshipHistoryInteractor.h"
#import "RelationshipHistoryDataSource.h"
#import "NetworkManager.h"
#import "Defaults.h"

@interface RelationshipHistoryInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) NSMutableArray *arrayOfHistoryObjects;
@property (nonatomic, strong) NSMutableArray *arrayOfUsersInStatusHistory;
@property (nonatomic, strong) RelationshipHistoryDataSource *relationshipDataSource;
@property (nonatomic, strong) id<NetworkProvider> networkProvider;

@end

@implementation RelationshipHistoryInteractor

-(id<UITableViewDataSource>)dataSource{
    
    if (!_dataSource) {
        _dataSource = self.relationshipDataSource;
    }
    
    return _dataSource;
}

-(RelationshipHistoryDataSource *)relationshipDataSource{
    
    if (!_relationshipDataSource) {
        _relationshipDataSource = [RelationshipHistoryDataSource new];
        _relationshipDataSource.interactor = self;
        
    }
    
    return _relationshipDataSource;
}

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        
        _networkProvider = [NetworkManager new];
    }
    return _networkProvider;
}

#pragma mark - Interactor Delegate Methods

-(void)retriveHistoryFormPendingNotificationsWithArray:(NSArray *)array{
    
    self.arrayOfHistoryObjects = [self pourStatusHistoryObjectsIntoMutableDictionary:array];
    [self getListOfUsersInStatusHistoryFromArray:[array mutableCopy]];
    [self.presenter reloadDatasource];
}
-(void)retrieveStatusHistoryForUser{
    
    NSString *userObjectId = [[PFUser currentUser] objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"StatusHistory"];
    [query whereKey:@"historyId" equalTo:userObjectId];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"StatusHistory"];
    [query2 whereKey:@"partnerId" equalTo:userObjectId];
    
    PFQuery *compoundQuery = [PFQuery orQueryWithSubqueries:@[query, query2]];
    [compoundQuery orderByDescending:@"statusDate"];
    [compoundQuery includeKey:@"StatusHistory.partnerId"];
    compoundQuery.limit = 20;

    [self.networkProvider queryDatabaseWithQuery:compoundQuery
                                         success:^(id responseObject) {
                                             
                                             self.arrayOfHistoryObjects = [self pourStatusHistoryObjectsIntoMutableDictionary:responseObject];
                                             [self getListOfUsersInStatusHistoryFromArray:responseObject];
                                             [self.presenter reloadDatasource];
                                             
                                         } failure:^(NSError *error) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             NSLog(@"This is the error: %@", error.localizedDescription);

                                         }];
    
    [self.presenter startAnimatingActivityView];
}

-(void)getListOfUsersInStatusHistoryFromArray:(NSMutableArray *)array{
    
    NSMutableArray *arrayOfObjectIdsForQueries = [NSMutableArray new];
    NSMutableArray *arrayOfQueries = [NSMutableArray new];
    NSMutableArray *arrayOfQueries2 = [NSMutableArray new];

    for (PFObject *object in array) {
        if (object[@"partnerId"]) {
            
            NSString *objectId = object[@"partnerId"];
            if ([arrayOfObjectIdsForQueries containsObject:objectId]) {
                
            }
            else{
                
                [arrayOfObjectIdsForQueries addObject:objectId];
            }
        }
    }
    
    for (NSString *string in arrayOfObjectIdsForQueries) {
        PFQuery *subQuery = [PFUser query];
        PFQuery *subQuery2 = [PFQuery queryWithClassName:@"AnonymousUser"];
        [subQuery whereKey:@"objectId" equalTo:string];
        [subQuery2 whereKey:@"objectId" equalTo:string];
        [arrayOfQueries addObject:subQuery];
        [arrayOfQueries2 addObject:subQuery2];

    }

    PFQuery *query = [PFQuery orQueryWithSubqueries:arrayOfQueries];
    PFQuery *query2 = [PFQuery orQueryWithSubqueries:arrayOfQueries2];

    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                             

                                             self.arrayOfUsersInStatusHistory = responseObject;
                                             [self getListOfAnonymousUsersInStatusHistoryWithQuery:query2];
                                             
                                         } failure:^(NSError *error) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             
                                             
                                         }];
    
    [self.presenter startAnimatingActivityView];
}

-(void)getListOfAnonymousUsersInStatusHistoryWithQuery:(PFQuery *)query{
    
    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             [self.arrayOfUsersInStatusHistory addObjectsFromArray:responseObject];
                                             [self.presenter reloadDatasource];
                                             
                                         } failure:^(NSError *error) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             NSLog(@"This is the error %@", error.localizedDescription);
                                             
                                         }];
}

-(NSArray *)returnArrayOfHistoryObjects{
    
    return self.arrayOfHistoryObjects;
}

-(NSMutableArray *)returnArrayOfUsersInStatusHistory{

   return  self.arrayOfUsersInStatusHistory;
}

-(NSMutableArray *)pourStatusHistoryObjectsIntoMutableDictionary:(NSArray *)array{
    
    NSMutableArray *finalArray = [NSMutableArray new];

    for (PFObject *object in array) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        if (object[@"partnerId"]) {
            [dict setObject:object[@"partnerId"] forKey:@"partnerId"];

        }
        else{
            
            [dict setObject:@"no partner id" forKey:@"partnerId"];

        }
        [dict setObject:[object objectId] forKey:@"objectId"];
        [dict setObject:object[@"statusType"] forKey:@"statusType"];
        [dict setObject:object[@"statusDate"] forKey:@"statusDate"];

        if (object[@"partnerName"]) {
            [dict setObject:object[@"partnerName"] forKey:@"partnerName"];

        }
        else{
            
            [dict setObject:@"" forKey:@"partnerName"];

        }
        
        if (object[@"statusEndDate"]) {
            [dict setObject:object[@"statusEndDate"] forKey:@"statusEndDate"];

        }
        else{
            
            [dict setObject:@"Till Date" forKey:@"statusEndDate"];

        }
        

        [finalArray addObject:dict];
    }

    return finalArray;
}

@end

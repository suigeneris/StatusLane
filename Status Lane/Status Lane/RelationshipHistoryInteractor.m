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

@interface RelationshipHistoryInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) NSMutableArray *arrayOfHistoryObjects;
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

-(void)retrieveStatusHistoryForUser{
    
    NSString *userObjectId = [[PFUser currentUser] objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"StatusHistory"];
    [query whereKey:@"historyId" equalTo:userObjectId];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"StatusHistory"];
    [query2 whereKey:@"partnerId" equalTo:userObjectId];
    
    PFQuery *compoundQuery = [PFQuery orQueryWithSubqueries:@[query, query2]];
    [compoundQuery orderByDescending:@"statusDate"];
    compoundQuery.limit = 20;

    [self.networkProvider queryDatabaseWithQuery:compoundQuery
                                         success:^(id responseObject) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             self.arrayOfHistoryObjects = responseObject;
                                             [self.presenter reloadDatasource];
                                             
                                         } failure:^(NSError *error) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             NSLog(@"This is the error: %@", error.localizedDescription);

                                         }];
    
    [self.presenter startAnimatingActivityView];
}

-(NSArray *)returnArrayOfHistoryObjects{
    
    return self.arrayOfHistoryObjects;
}


@end

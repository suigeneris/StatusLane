//
//  PendingRequestInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "PendingRequestInteractor.h"
#import "PendingRequestsDataSource.h"

@interface PendingRequestInteractor ()

@property (nonatomic, strong) id<UITableViewDataSource> datasource;
@property (nonatomic, strong) PendingRequestsDataSource *pendingRequestsDatasource;

@end

@implementation PendingRequestInteractor


-(id<UITableViewDataSource>)dataSource{
    
    if (!_datasource) {
        
        _datasource = self.pendingRequestsDatasource;
    }
    
    return _datasource;
}


-(PendingRequestsDataSource *)pendingRequestsDatasource{
    
    if (!_pendingRequestsDatasource) {
        
        _pendingRequestsDatasource = [PendingRequestsDataSource new];
        
    }
    
    return _pendingRequestsDatasource;
}



@end

//
//  RelationshipHistoryInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "RelationshipHistoryInteractor.h"
#import "RelationshipHistoryDataSource.h"

@interface RelationshipHistoryInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) RelationshipHistoryDataSource *relationshipDataSource;

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
        
    }
    
    return _relationshipDataSource;
}


@end

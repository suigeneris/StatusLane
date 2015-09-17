//
//  RelationshipHistoryContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RelationshipHistoryInteractorDatasource <NSObject>

-(id<UITableViewDataSource>)dataSource;


@end

@protocol RelationshipHistoryInteractor <NSObject>

-(void)retrieveStatusHistoryForUser;
-(NSArray *)returnArrayOfHistoryObjects;
-(NSMutableArray *)returnArrayOfUsersInStatusHistory;

@end

@protocol RelationshipHistoryPresenter <NSObject>

-(void)reloadDatasource;
-(void)startAnimatingActivityView;
-(void)stopAnimatingActivitiyView;

@end
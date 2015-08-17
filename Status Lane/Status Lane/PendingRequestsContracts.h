//
//  PendingRequestsContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PendingRequestsInteractorDataSource <NSObject>

-(id<UITableViewDataSource>)dataSource;


@end


@protocol PendingRequestsInteractor <NSObject>

-(NSArray *)returnArrayOfNotifications;
-(NSArray *)returnArrayOfNotificationSenders;
-(void)retrieveArrayOfNotificationsForUser;
-(void)rejectNotificationForUserAtIndexPath:(NSIndexPath *)indexPath;
-(void)acceptNotificationForUserAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol PendingRequestsPresenter <NSObject>

-(void)reloadDatasource;
-(void)startAnimatingActivityView;
-(void)stopAnimatingActivitiyView;
-(void)deleteTableViewRowWithIndexPaths:(NSIndexPath *)indexPath;

@end
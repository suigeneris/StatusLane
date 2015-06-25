//
//  SearchUsersContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@protocol SearchUsersInteractorDelegate <NSObject>


-(NSArray *)returnArrayOfSearchResults;

@end


@protocol SearchUsersInteractorDataSource <NSObject>

-(id<UITableViewDataSource>)dataSource;


@end

@protocol SearchUsersPresenterDelegate <NSObject>

-(void)setFrontViewController;
-(void)resetFrontViewController;
-(void)reloadData;
-(void)showUserProfileForUser:(PFUser *)user;

@end
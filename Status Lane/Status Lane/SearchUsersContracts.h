//
//  SearchUsersContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol SearchUsersInteractorDelegate <NSObject>

@end


@protocol SearchUsersInteractorDataSource <NSObject>

-(id<UITableViewDataSource>)dataSource;


@end

@protocol SearchUsersPresenterDelegate <NSObject>

-(void)setFrontViewController;
-(void)resetFrontViewController;

@end
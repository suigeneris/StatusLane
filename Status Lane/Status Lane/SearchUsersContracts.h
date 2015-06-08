//
//  SearchUsersContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchUsersInteractorDelegate <NSObject>

@end


@protocol SearchUsersInteractorDataSource <NSObject>


@end

@protocol SearchUsersPresenterDelegate <NSObject>

-(void)setFrontViewController;
-(void)resetFrontViewController;

@end
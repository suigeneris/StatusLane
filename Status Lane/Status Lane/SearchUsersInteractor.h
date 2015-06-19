//
//  SearchUsersInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchUsersContracts.h"
#import <UIKit/UIKit.h>

@interface SearchUsersInteractor : NSObject <SearchUsersInteractorDelegate, UITableViewDelegate, UISearchBarDelegate, SearchUsersInteractorDataSource>

@property (nonatomic, weak) id <SearchUsersPresenterDelegate> presenter;

@end

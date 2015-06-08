//
//  SearchUsers.h
//  Status Lane
//
//  Created by Jonathan Aguele on 21/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchUsersContracts.h"

@interface SearchUsersPresenter : UIViewController <SearchUsersPresenterDelegate>

@property (nonatomic, strong) id <SearchUsersInteractorDelegate, UISearchBarDelegate> interactor;

@end

//
//  ReferAFriendPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReferAFriendContracts.h"

@interface ReferAFriendPresenter : UIViewController <ReferAFriendPresenter>

@property (nonatomic, strong) id<ReferAFriendInteractor> interactor;

@end

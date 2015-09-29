//
//  ReferAFriendInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/09/2015.
//  Copyright © 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReferAFriendContracts.h"
#import <MessageUI/MessageUI.h>

@interface ReferAFriendInteractor : NSObject <ReferAFriendInteractor>

@property (nonatomic, weak) id<ReferAFriendPresenter> presenter;

@end

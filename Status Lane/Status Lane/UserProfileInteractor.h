//
//  UserProfileInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 12/10/2015.
//  Copyright © 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileContracts.h"

@interface UserProfileInteractor : NSObject <UserProfileInteractor>

@property (nonatomic, weak) id<UserProfilePresenter> presenter;

@end

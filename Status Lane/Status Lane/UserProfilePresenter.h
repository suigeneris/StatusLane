//
//  UserProfilePresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 21/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UserProfileContracts.h"

@interface UserProfilePresenter : UIViewController <UserProfilePresenter>

@property (nonatomic, strong) id<UserProfileInteractor> interactor;
@property (nonatomic, strong) id user;
@property (nonatomic, assign) BOOL animateViewOnAppear;

@end

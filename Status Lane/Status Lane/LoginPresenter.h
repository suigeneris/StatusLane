//
//  LoginPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInteractor.h"

@interface LoginPresenter : UIViewController

@property (nonatomic) id<LoginInteractor> interactor;


@end

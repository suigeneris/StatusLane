//
//  CreateAccountPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 14/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateAccountContracts.h"

@interface CreateAccountPresenter : UIViewController <CreateAccountPresenter>

@property (nonatomic) id<CreateAccountInteractor> interactor;

@end

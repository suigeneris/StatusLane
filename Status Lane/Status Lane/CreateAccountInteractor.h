//
//  CreateAccountInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 14/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateAccountContracts.h"

@interface CreateAccountInteractor : NSObject <CreateAccountInteractor>

@property (nonatomic) id <CreateAccountPresenter> presenter;

@end

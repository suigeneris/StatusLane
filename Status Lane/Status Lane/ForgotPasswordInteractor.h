//
//  ForgotPasswordInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForgotPasswordContracts.h"
@interface ForgotPasswordInteractor : NSObject <ForgotPasswordInteractor>

@property (nonatomic, weak) id <ForgotPasswordPresenter> presenter;

@end

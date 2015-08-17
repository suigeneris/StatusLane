//
//  ForgotPasswordPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgotPasswordContracts.h"

@interface ForgotPasswordPresenter : UIViewController <ForgotPasswordPresenter>

@property (nonatomic) id<ForgotPasswordInteractor> interactor;

@end

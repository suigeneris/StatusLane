//
//  BurgerMenuPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BurgerMenuContracts.h"

@interface BurgerMenuPresenter : UIViewController <BurgerMenuPresenter>

@property (nonatomic, strong) id <BurgerMenuInteractor> interactor;

@end

//
//  BurgerMenuInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BurgerMenuContracts.h"

@interface BurgerMenuInteractor : NSObject <BurgerMenuInteractor>

@property (nonatomic, weak) id<BurgerMenuPresenter> presenter;

@end

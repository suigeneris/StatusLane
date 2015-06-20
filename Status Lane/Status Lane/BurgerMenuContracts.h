//
//  BurgerMenuContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BurgerMenuPresenter <NSObject>

@end

@protocol BurgerMenuInteractor <NSObject>

-(UIImage *)retrieveProfileImageFromFile;


@end
//
//  RegisteredUserInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 28/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChoosePartnerContracts.h"

@interface RegisteredUserInteractor : NSObject

@property (nonatomic, weak) id <ChoosePartnerPresenterDelegate> presenter;

@end
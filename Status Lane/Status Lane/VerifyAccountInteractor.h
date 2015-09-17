//
//  VerifyAccountInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 21/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VerifyAccountContracts.h"



@interface VerifyAccountInteractor : NSObject <VerifyAccountInteractor>

@property (nonatomic, weak) id <VerifyAccountPresenter> presenter;


@end

//
//  ChoosePartnerInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChoosePartnerContracts.h"
#import "Defaults.h"
#import <UIKit/UIKit.h>

@interface ChoosePartnerInteractor : NSObject <ChoosePartnerInteractorDelegate, UITableViewDelegate, ChoosePartnerInteractorDataSource>


@property (nonatomic, weak) id<ChoosePartnerPresenterDelegate> presenter;

@end

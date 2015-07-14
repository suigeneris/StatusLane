//
//  ChoosePartnerDataSource.h
//  Status Lane
//
//  Created by Jonathan Aguele on 31/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChoosePartnerContracts.h"
#import <UIKit/UIKit.h>

@interface ChoosePartnerDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, weak) id <ChoosePartnerInteractorDelegate> interactor;

@end

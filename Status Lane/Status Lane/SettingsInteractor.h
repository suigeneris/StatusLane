//
//  SettingsInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SettingsContracts.h"

@interface SettingsInteractor : NSObject <UITableViewDelegate, SettingsInteractor>

@property (nonatomic, weak) id<SettingsPresenterDelegate> presenter;

@end

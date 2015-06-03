//
//  SettingsPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsContracts.h"
@interface SettingsPresenter : UITableViewController

@property (nonatomic) id <UITableViewDelegate, SettingsInteractor> interactor;

@end

//
//  PendingRequestInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PendingRequestsContracts.h"
#import "PendingRequestsPresenter.h"

@interface PendingRequestInteractor : NSObject <UITableViewDelegate, PendingRequestsInteractorDataSource>

@property (nonatomic, weak) PendingRequestsPresenter *presenter;

@end

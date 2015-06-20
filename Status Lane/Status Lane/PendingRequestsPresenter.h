//
//  PendingRequestsPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingRequestsContracts.h"

@interface PendingRequestsPresenter : UIViewController

@property (nonatomic, strong) id <UITableViewDelegate, PendingRequestsInteractorDataSource> interactor;


@end

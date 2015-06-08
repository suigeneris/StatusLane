//
//  PurchaseRequestsPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 21/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseRequestsContracts.h"

@interface PurchaseRequestsPresenter : UIViewController <PurchaseRequestsPresenterDelegate>

@property (nonatomic, strong) id <PurchaseRequestsInteractorDelegate, PurchaseRequestInteractorDataSource, UITableViewDelegate> interactor;


@end

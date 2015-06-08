//
//  PurchaseRequestsInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 07/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PurchaseRequestsContracts.h"

@interface PurchaseRequestsInteractor : NSObject <UITableViewDelegate, PurchaseRequestsInteractorDelegate, PurchaseRequestInteractorDataSource>

@property (nonatomic, weak) id<PurchaseRequestsPresenterDelegate> presenter;

@end

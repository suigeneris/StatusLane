//
//  RelationshipHistoryInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RelationshipHistoryContracts.h"
#import "RelationshipHistoryPresenter.h"

@interface RelationshipHistoryInteractor : NSObject <UITableViewDelegate, RelationshipHistoryInteractorDatasource, RelationshipHistoryInteractor>

@property (nonatomic, weak) RelationshipHistoryPresenter *presenter;

@end

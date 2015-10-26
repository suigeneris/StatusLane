//
//  RelatioinshipHistoryPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelationshipHistoryContracts.h"

@interface RelationshipHistoryPresenter : UIViewController <RelationshipHistoryPresenter>

@property (nonatomic, strong) id <UITableViewDelegate, RelationshipHistoryInteractorDatasource, RelationshipHistoryInteractor> interactor;

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, assign) BOOL fromPendingRequests;

@end

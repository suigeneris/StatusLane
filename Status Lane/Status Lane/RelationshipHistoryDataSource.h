//
//  RelationshipHistoryDataSource.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RelationshipHistoryContracts.h"

#import "UIKit/UIKit.h"

@interface RelationshipHistoryDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, weak) id <RelationshipHistoryInteractor> interactor;


@end

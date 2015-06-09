//
//  StatusListContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 08/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol StatusListInteractorDataSource <NSObject>

-(id<UITableViewDataSource>)dataSource;

@end

@protocol StatusListInteractorDelegate <NSObject>

@end

@protocol StatusListPresenterDelegate <NSObject>

-(void)dismissView;

@end

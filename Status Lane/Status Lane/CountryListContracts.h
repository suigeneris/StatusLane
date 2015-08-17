//
//  CountryListContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 26/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CountryListPresenterDelegate <NSObject>

-(void)dismissView;

@end

@protocol CountryListInteractorDataSource <NSObject>

-(id<UITableViewDataSource>)dataSource;

@end
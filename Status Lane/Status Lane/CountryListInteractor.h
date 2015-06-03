//
//  CountryListInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 26/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CountryListContracts.h"

@interface CountryListInteractor : NSObject <UITableViewDelegate, CountryListInteractorDataSource>

@property (nonatomic, weak) id<CountryListPresenterDelegate> presenter;

@end

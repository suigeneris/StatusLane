//
//  CountryListPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 26/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryListContracts.h"

@interface CountryListPresenter : UIViewController <CountryListPresenterDelegate>

@property (nonatomic, strong) id <UITableViewDelegate, CountryListInteractorDataSource> interactor;

@end

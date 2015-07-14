//
//  ChoosePartnerPresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosePartnerInteractor.h"

@interface ChoosePartnerPresenter : UIViewController <ChoosePartnerPresenterDelegate>

@property (nonatomic, strong) id<ChoosePartnerInteractorDelegate, UITableViewDelegate, ChoosePartnerInteractorDataSource, UISearchBarDelegate> interactor;
@property (nonatomic, strong) NSString *usersChosenStatus;
@end

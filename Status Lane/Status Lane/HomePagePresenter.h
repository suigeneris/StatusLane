//
//  HomePagePresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageContracts.h"

@interface HomePagePresenter : UIViewController <HomePagePresenterDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) id <HomePageInteractorDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> interactor;
@end

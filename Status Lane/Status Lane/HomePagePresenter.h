//
//  HomePagePresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageContracts.h"
#import "RSKImageCropViewController.h"


@interface HomePagePresenter : UIViewController <HomePagePresenterDelegate>

@property (nonatomic, strong) id <HomePageInteractorDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate> interactor;
@end

//
//  HomePageInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 30/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageContracts.h"



@interface HomePageInteractor : NSObject <HomePageInteractorDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<HomePagePresenterDelegate> presenter;


@end

//
//  VerifyAccountViewController.h
//  Status Lane
//
//  Created by Jonathan Aguele on 19/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerifyAccountContracts.h"

@interface VerifyAccountPresenter : UIViewController <VerifyAccountPresenter>

@property (nonatomic, strong) id <VerifyAccountInteractor> interactor;

@property (nonatomic, strong) NSString *phonenumber;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *verificationCode;



@end

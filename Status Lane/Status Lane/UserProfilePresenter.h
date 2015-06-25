//
//  UserProfilePresenter.h
//  Status Lane
//
//  Created by Jonathan Aguele on 21/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserProfilePresenter : UIViewController

@property (nonatomic, strong) PFUser *user;
@end

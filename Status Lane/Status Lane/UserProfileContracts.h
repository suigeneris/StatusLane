//
//  UserProfileContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 12/10/2015.
//  Copyright © 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol UserProfileInteractor <NSObject>

-(void)sendStatusRequestToUser:(PFUser *)user;
-(void)sendStatusHistoryRequestToUser:(PFUser *)user;

@end


@protocol UserProfilePresenter <NSObject>

-(void)startAnimating;
-(void)stopAnimating;
-(void)showResponseViewWithMessage:(NSString *)message andTitle:(NSString *)title;

@end
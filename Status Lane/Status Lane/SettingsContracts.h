//
//  SettingsContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SettingsInteractor <NSObject>

-(id<UITableViewDataSource>)dataSource;
-(void)deleteUserAccount;
-(void)updateUserDetailsIfEmailChanged:(NSString *)email;

@end


@protocol SettingsPresenterDelegate <NSObject>

@optional
-(void)logOut;
-(void)showAlertView;

@end
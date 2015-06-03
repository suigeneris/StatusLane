//
//  ChoosePartnerContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ChoosePartnerInteractorDelegate <NSObject>

-(NSString *)requestCountryCode;
-(void)askUserForPermissionToViewContacts;
-(void)openSettings;

@end

@protocol ChoosePartnerInteractorDataSource <NSObject>

-(id<UITableViewDataSource>)dataSource;

@end

@protocol ChoosePartnerPresenterDelegate <NSObject>

-(void)showAlertWithTitle:(NSString *)title errorMessage:(NSString *)error andActionTitle:(NSString *)actionTitle;
-(void)reloadData;

@end
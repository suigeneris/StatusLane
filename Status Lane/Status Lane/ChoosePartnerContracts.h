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
-(NSArray *)returnSearchResults;

-(void)openSettings;
-(void)askUserForPermissionToViewContacts;
-(void)saveStatusToDefaults:(NSString *)string andPartnerName:(NSString *)partnerNameString;
-(void)passArrayOfContacts:(NSArray *)contacts withNumbers:(NSMutableArray *)numbers;
-(void)updateUserPartnerWithFullName:(NSString *)fullName andNumber:(NSString *)number;


@end

@protocol ChoosePartnerInteractorDataSource <NSObject>

-(id<UITableViewDataSource>)dataSource;
@end

@protocol ChoosePartnerPresenterDelegate <NSObject>

-(void)showAlertWithTitle:(NSString *)title errorMessage:(NSString *)error andActionTitle:(NSString *)actionTitle;
-(void)reloadData;
-(void)dismissView;
-(void)dismissTabelViewWithPartnerName:(NSString *)name andNumber:(NSString *)number;
-(void)dismissSearchBar;
-(void)showErrorView:(NSString *)errorMessage;
-(void)startAnimatingActivityView;
-(void)stopAnimatingActivitiyView;

@end
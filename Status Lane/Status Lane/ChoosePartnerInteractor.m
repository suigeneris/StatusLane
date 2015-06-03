//
//  ChoosePartnerInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ChoosePartnerInteractor.h"
#import "CountryCode.h"
#import "ChoosePartnerDataSource.h"
#import "ChoosePartnerPresenter.h"
#import <AddressBook/AddressBook.h>


@interface ChoosePartnerInteractor()

@property (nonatomic, strong) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) ChoosePartnerDataSource *choosePartnerDataSource;

@end


@implementation ChoosePartnerInteractor



#pragma mark ChoosePartnerInteractor Delegate

-(NSString *)requestCountryCode{
    
    CountryCode *code = [CountryCode sharedInstance];
    NSString *string = code.countryCode;
    return string;

}

-(void)askUserForPermissionToViewContacts{
    

    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        
        [self.presenter showAlertWithTitle:@"May we have your permisson" errorMessage:@"We would like to access your contacts if thats ok with you" andActionTitle:@"OK"];
        
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
    }
    else {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
                if (!granted){
                    
                    [self.presenter showAlertWithTitle:@"May we have your permisson" errorMessage:@"We would like to access your contacts if thats ok with you" andActionTitle:@"OK"];
                    
                    return;
                }
                
                else{
                    
                    [self.presenter reloadData];
                
                }
            
        });
        
            
        });
    }
    
}

-(void)openSettings{
    
    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:appSettings];
}

#pragma mark ChoosePartnerInteractor DataSource

-(id<UITableViewDataSource>)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = self.choosePartnerDataSource;
    }

    return _dataSource;
}


-(ChoosePartnerDataSource *)choosePartnerDataSource{
    
    if (!_choosePartnerDataSource) {
        
        _choosePartnerDataSource = [ChoosePartnerDataSource new];
        
    }
    
    return _choosePartnerDataSource;
}

@end

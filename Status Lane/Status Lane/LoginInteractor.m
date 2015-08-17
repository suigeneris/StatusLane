//
//  LoginInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "LoginInteractor.h"
#import "CountryCode.h"
#import "Defaults.h"
#import "NetworkManager.h"

@interface LoginInteractor()

@property (nonatomic, strong) id <NetworkProvider> networkProvider;

@end

@implementation LoginInteractor

#pragma mark -Login Interactor Delegate

-(NSString *)requestCountryCode{
    
    CountryCode *code = [CountryCode sharedInstance];
    NSString *string = code.countryCode;
    return string;
    
}

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        _networkProvider = [NetworkManager new];
        
    }
    return _networkProvider;
}


-(void)attemptLoginWithUsername:(NSString *)username andPassword:(NSString *)password{
    
    
    [self.networkProvider loginWithUsername:username
                                andPassword:password
                                    success:^(id responseObject) {
                                        
                                        [self.presenter hideActivityView];
                                        PFUser *user = responseObject;
                                        [Defaults setStatus:user[@"status"]];
                                        [self.presenter login];
                                        
                                    } failure:^(NSError *error) {
                                        
                                        [self.presenter hideActivityView];
                                        if (error.code == kPFErrorObjectNotFound) {
                                            
                                            [self.presenter showErrorViewWithErrorMessage:@"Sorry we cant seem to match your details with any accounts"];
                                        }
                                        
                                        else if(error.code == kPFErrorTimeout || error.code == kPFErrorConnectionFailed){
                                            
                                            [self.presenter showErrorViewWithErrorMessage:@"Cannot Connect To Servers, Please check your Internet Connection"];
                                            
                                        }
                                        else{
                                            
                                            [self.presenter showErrorViewWithErrorMessage:@"Please Check Your Phone Number and Password and Try again"];
                                        }
                                    }];
    
    [self.presenter showActivityView];

    
}

-(void)loginCachedUser{
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        [Defaults setStatus:currentUser[@"status"]];
        [self.presenter login];

    } else {
        
    }
}



#pragma mark - Interanl Methods




@end

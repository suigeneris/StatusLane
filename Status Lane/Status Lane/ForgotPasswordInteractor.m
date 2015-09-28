//
//  ForgotPasswordInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ForgotPasswordInteractor.h"
#import "NetworkManager.h"
#import "Defaults.h"

@interface ForgotPasswordInteractor ()

@property (nonatomic, strong) id<NetworkProvider> networkProvider;

@end

@implementation ForgotPasswordInteractor

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        _networkProvider = [NetworkManager new];
    }
    return _networkProvider;
}

#pragma mark - ForgotPassword Interactor Delegate



-(void)resetPasswordForEmail:(NSString *)email{
    
    
    [self.networkProvider resetPasswordForUserWithEmail:email
                                               succcess:^(id responseObject) {
                                                   
                                                   [self.presenter showErrorViewWithMessage:@"Please check your email for your Password reset link" andTitle:@"Yaaay!"];
                                                   
                                               } failure:^(NSError *error) {
                                                   
                                                   [self.presenter showErrorViewWithMessage:error.localizedDescription andTitle:@"OOOOPs!"];
                                                   
                                               }];
    
}




#pragma mark - Internal Methods
















@end

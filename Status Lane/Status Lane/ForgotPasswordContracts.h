//
//  ForgotPasswordContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ForgotPasswordInteractor <NSObject>

-(void)resetPasswordForEmail:(NSString *)email;

@end


@protocol ForgotPasswordPresenter <NSObject>

-(void)showErrorViewWithMessage:(NSString *)message color:(UIColor *)color andTitle:(NSString *)title;
-(void)dismissView;


@end
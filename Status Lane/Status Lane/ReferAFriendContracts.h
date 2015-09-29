//
//  ReferAFriendContracts.h
//  Status Lane
//
//  Created by Jonathan Aguele on 29/09/2015.
//  Copyright © 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ReferAFriendInteractor <NSObject>

-(UIViewController *)returnMailViewController;
-(UIViewController *)returnSMSViewController;

@end

@protocol ReferAFriendPresenter <NSObject>

-(void)dismissMailComposer;

@end

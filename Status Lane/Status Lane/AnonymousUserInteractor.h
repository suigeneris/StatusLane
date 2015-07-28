//
//  AnonymousUserInteractor.h
//  Status Lane
//
//  Created by Jonathan Aguele on 27/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChoosePartnerContracts.h"

@interface AnonymousUserInteractor : NSObject

@property (nonatomic, weak) id<ChoosePartnerPresenterDelegate> presenter;

-(void)searchAnonymousUserWithUsername:(NSString *)username andfullName:(NSString *)fullName andStatus:(NSString *)status;

@end

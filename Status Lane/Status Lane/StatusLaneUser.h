//
//  StatusLaneUser.h
//  Status Lane
//
//  Created by Jonathan Aguele on 13/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StatusLaneUser : NSObject <NSCoding>

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *partnerFullName;
@property (nonatomic, strong) NSString *phoneNumberCountryCode;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) UIImage *backgroundImage;


@end

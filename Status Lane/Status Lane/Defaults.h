//
//  Defaults.h
//  Status Lane
//
//  Created by Jonathan Aguele on 14/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusLaneUser.h"

@interface Defaults : NSObject

+(NSString *)fullName;
+(void)setFullName:(NSString *)fullName;

+(NSString *)partnerFullName;
+(void)setPartnerFullName:(NSString *)partnerFullName;

+(NSString *)phoneNumberCountyCode;
+(void)setPhoneNumberCountryCode:(NSString *)phoneNumberCountyCode;

+(NSString *)phoneNumber;
+(void)setPhoneNumber:(NSString *)phoneNumber;

+(NSString *)emailAddress;
+(void)setEmailAddress:(NSString *)emailAddress;

+(NSString *)username;
+(void)setUsername:(NSString *)username;

+(NSString *)sex;
+(void)setSex:(NSString *)sex;

+(NSString *)status;
+(void)setStatus:(NSString *)status;

+(UIImage *)profileImage;
+(void)setProfileImage:(UIImage *)profileImage;

+(UIImage *)backgroundImage;
+(void)setBackgroundImage:(UIImage *)backgroundImage;

+(NSString *)password;
+(void)setPassword:(NSString *)password;

+(StatusLaneUser *)user;
+(void)setUser:(StatusLaneUser *)user;

+(void)putValue:(id)value forkey:(NSString *)key;
+(id)getValue:(NSString *)key;


+(void)clearDefaults;

@end

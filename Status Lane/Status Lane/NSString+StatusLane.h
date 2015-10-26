//
//  NSString+StatusLane.h
//  Status Lane
//
//  Created by Jonathan Aguele on 14/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StatusLane)

+(NSString *)documentsPathForFileName:(NSString *)name;
+(void)deleteDocumentForName:(NSString *)name;
+(NSDictionary *)allFormatsForPhoneNumber:(NSString *)phoneNumber;
+(BOOL)isPhoneNumberValid:(NSString*)phoneNumber;
-(BOOL)isValidEmail;
+(NSString *)verifyObjectId:(NSString *)objectId;

@end

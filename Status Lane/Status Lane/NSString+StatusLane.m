//
//  NSString+StatusLane.m
//  Status Lane
//
//  Created by Jonathan Aguele on 14/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "NSString+StatusLane.h"
#import "NBPhoneNumberUtil.h"

@implementation NSString (StatusLane)

+(NSString *)documentsPathForFileName:(NSString *)name{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    return [documentPath stringByAppendingPathComponent:name];
}


+(bool)isPhoneNumberValid:(NSString*)phoneNumber{
    
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc]init];
    
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:phoneNumber
                                 defaultRegion:@"" error:&anError];
    if (anError == nil) {
//        // Should check error
//        NSLog(@"isValidPhoneNumber ? [%@]", [phoneUtil isValidNumber:myNumber] ? @"YES":@"NO");
//        
//        // E164          : +436766077303
//        NSLog(@"E164          : %@", [phoneUtil format:myNumber
//                                          numberFormat:NBEPhoneNumberFormatE164
//                                                 error:&anError]);
//        // INTERNATIONAL : +43 676 6077303
//        NSLog(@"INTERNATIONAL : %@", [phoneUtil format:myNumber
//                                          numberFormat:NBEPhoneNumberFormatINTERNATIONAL
//                                                 error:&anError]);
//        // NATIONAL      : 0676 6077303
//        NSLog(@"NATIONAL      : %@", [phoneUtil format:myNumber
//                                          numberFormat:NBEPhoneNumberFormatNATIONAL
//                                                 error:&anError]);
//        // RFC3966       : tel:+43-676-6077303
//        NSLog(@"RFC3966       : %@", [phoneUtil format:myNumber
//                                          numberFormat:NBEPhoneNumberFormatRFC3966
//                                                 error:&anError]);
    }
    
    else {
//        NSLog(@"Error : %@", [anError localizedDescription]);
    }
    
//    NSLog (@"extractCountryCode [%@]", [phoneUtil extractCountryCode:phoneNumber nationalNumber:nil]);
//    
//    NSString *nationalNumber = nil;
//    NSNumber *countryCode = [phoneUtil extractCountryCode:phoneNumber nationalNumber:&nationalNumber];
//    
//    NSLog (@"extractCountryCode [%@] [%@]", countryCode, nationalNumber);
    
    
    return [phoneUtil isValidNumber:myNumber];
}


@end

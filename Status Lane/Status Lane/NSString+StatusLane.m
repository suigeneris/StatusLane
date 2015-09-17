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

+(void)deleteDocumentForName:(NSString *)name{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString documentsPathForFileName:name];
    [fileManager removeItemAtPath:filePath error:&error];
}

+(BOOL)isPhoneNumberValid:(NSString*)phoneNumber{
    
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

-(BOOL)isValidEmail{

    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

+(NSDictionary *)allFormatsForPhoneNumber:(NSString *)phoneNumber{
    
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc]init];
    NSError *anError = nil;
    
    NBPhoneNumber *myNumber = [phoneUtil parse:phoneNumber
                                 defaultRegion:@"" error:&anError];

    NSString *nationalNumber = nil;
    
    NSString *finalNationalNumber = [NSString stringWithFormat:@"+%@%@", [phoneUtil extractCountryCode:phoneNumber nationalNumber:&nationalNumber], [phoneUtil format:myNumber numberFormat:NBEPhoneNumberFormatNATIONAL error:&anError]];
    
    NSDictionary *phoneNumberFormats = @{@"E164": [phoneUtil format:myNumber numberFormat:NBEPhoneNumberFormatE164
                                                              error:&anError],
                                         @"National" : [finalNationalNumber stringByReplacingOccurrencesOfString:@" "
                                                                                                      withString:@""
                                                        
                                         
                                         ]};
    
    return phoneNumberFormats;
}

@end







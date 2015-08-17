//
//  AddressBookContact.m
//  Status Lane
//
//  Created by Jonathan Aguele on 07/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "AddressBookContact.h"

@implementation AddressBookContact

-(NSString *)description{
    
    NSString *string = [NSString stringWithFormat:@"Contact Name: %@ \rContact Phone Numbers: %@", self.contactName, self.arrayOfContacts];
    return string;
}
@end

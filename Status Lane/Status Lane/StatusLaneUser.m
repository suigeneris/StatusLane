//
//  StatusLaneUser.m
//  Status Lane
//
//  Created by Jonathan Aguele on 13/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "StatusLaneUser.h"

#define kFullNameKey @"fullName"
#define kPartnerFullNameKey @"partnerFullName"
#define kPhoneNumberCountryCode @"phoneNumberCountryCode"
#define KPhoneNumber @"phoneNumber"
#define kEmailAddress @"emailAddress"
#define kUsername @"username"
#define kSex @"sex"
#define kStatus @"status"
#define kProfileImage @"profileImage"
#define kBackgroundImage @"backgroundImage"



@implementation StatusLaneUser


-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    if (self) {
        
        self.fullName = [dictionary objectForKey:kFullNameKey];
        self.partnerFullName = [dictionary objectForKey:kPartnerFullNameKey];
        self.phoneNumberCountryCode = [dictionary objectForKey:kPhoneNumberCountryCode];
        self.phoneNumber = [dictionary objectForKey:KPhoneNumber];
        self.emailAddress = [dictionary objectForKey:kEmailAddress];
        self.username = [dictionary objectForKey:kUsername];
        self.sex = [dictionary objectForKey:kSex];
        self.status = [dictionary objectForKey:kStatus];
        self.profileImage = [dictionary objectForKey:kProfileImage];
        self.backgroundImage = [dictionary objectForKey:kBackgroundImage];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_fullName forKey:kFullNameKey];
    [aCoder encodeObject:_partnerFullName forKey:kPartnerFullNameKey];
    [aCoder encodeObject:_phoneNumberCountryCode forKey:kPhoneNumberCountryCode];
    [aCoder encodeObject:_phoneNumber forKey:KPhoneNumber];
    [aCoder encodeObject:_emailAddress forKey:kEmailAddress];
    [aCoder encodeObject:_username forKey:kUsername];
    [aCoder encodeObject:_sex forKey:kSex];
    [aCoder encodeObject:_status forKey:kStatus];
    [aCoder encodeObject:_profileImage forKey:kProfileImage];
    [aCoder encodeObject:_backgroundImage forKey:kBackgroundImage];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        
        self.fullName = [aDecoder decodeObjectForKey:kFullNameKey];
        self.partnerFullName = [aDecoder decodeObjectForKey:kPartnerFullNameKey];
        self.phoneNumberCountryCode = [aDecoder decodeObjectForKey:kPhoneNumberCountryCode];
        self.phoneNumber = [aDecoder decodeObjectForKey:KPhoneNumber];
        self.emailAddress = [aDecoder decodeObjectForKey:kEmailAddress];
        self.username = [aDecoder decodeObjectForKey:kUsername];
        self.sex = [aDecoder decodeObjectForKey:kSex];
        self.profileImage = [aDecoder decodeObjectForKey:kProfileImage];
        self.backgroundImage = [aDecoder decodeObjectForKey:kBackgroundImage];
        
    }
    
    return self;
}
@end

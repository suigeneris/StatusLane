//
//  Defaults.m
//  Status Lane
//
//  Created by Jonathan Aguele on 14/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "Defaults.h"
#import "NSString+StatusLane.h"
#import "KeyChainWrapper.h"
#import "UIImage+StatusLane.h"
#import "Parse/Parse.h"

#define kFullNameKey @"fullName"
#define kPhoneNumberCountryCodeKey @"phoneNumberCountryCode"
#define kphoneNumberKey @"phoneNumber"
#define kEmailAddressKey @"emailAddress"
#define kUsernameKey @"username"
#define kSex @"sex"
#define kStatus @"status"
#define kProfileImageKey @"profileImage"
#define kBackgroundKey @"backgroundImage"
#define kStatusLaneUserKey @"statusLaneUser"
#define kPasswordKey @"password"


@implementation Defaults

+(NSString *)fullName{
    
    return [self getValue:kFullNameKey];
}

+(void)setFullName:(NSString *)fullName{
    
    [self putValue:fullName forkey:kFullNameKey];
}


+(NSString *)phoneNumberCountyCode{
    
    return [self getValue:kPhoneNumberCountryCodeKey];
}

+(void)setPhoneNumberCountryCode:(NSString *)phoneNumberCountyCode{
    
    [self putValue:phoneNumberCountyCode forkey:kPhoneNumberCountryCodeKey];
}

+(NSString *)phoneNumber{
    
    return [self getValue:kphoneNumberKey];
    
}

+(void)setPhoneNumber:(NSString *)phoneNumber{
    
    [self putValue:phoneNumber forkey:kphoneNumberKey];
}


+(NSString *)emailAddress{
    
    return [self getValue:kEmailAddressKey];
}

+(void)setEmailAddress:(NSString *)emailAddress{
    
    [self putValue:emailAddress forkey:kEmailAddressKey];
    
}

+(NSString *)username{
    
    return [self getValue:kUsernameKey];
}


+(void)setUsername:(NSString *)username{
    
    [self putValue:username forkey:kUsernameKey];
}

+(NSString *)sex{
    
    return [self getValue:kSex];
    
}


+(void)setSex:(NSString *)sex{
    
    [self putValue:sex forkey:kSex];
}


+(NSString *)status{
    
    return [self getValue:kStatus];
}

+(void)setStatus:(NSString *)status{
    
    [self putValue:status forkey:kStatus];
    [self updatePFUserColoum:@"status" withInfo:status];
}


+(UIImage *)profileImage{

    NSString *filePath = [NSString documentsPathForFileName:@"profileImage.png"];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    UIImage *profileImage = [UIImage imageWithData:pngData];
    return profileImage;
}

+(void)setProfileImage:(UIImage *)profileImage{
    
    NSData *pngData = UIImagePNGRepresentation(profileImage);
    NSString *filePath = [NSString documentsPathForFileName:@"profileImage.png"];
    [pngData writeToFile:filePath atomically:YES];
    
    UIBackgroundTaskIdentifier backgoundTask;
    backgoundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        [[UIApplication sharedApplication] endBackgroundTask:backgoundTask];
    }];
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self updatePFUserProfileImage:profileImage];
        [[UIApplication sharedApplication]endBackgroundTask:backgoundTask];


    });
}

+(UIImage *)backgroundImage{
    
    NSString *filePath = [NSString documentsPathForFileName:@"backgroundImage.png"];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    UIImage *backgroundImage = [UIImage imageWithData:pngData];
    return backgroundImage;
}


+(void)setBackgroundImage:(UIImage *)backgroundImage{
    
    NSData *pngData = UIImagePNGRepresentation(backgroundImage);
    NSString *filePath = [NSString documentsPathForFileName:@"backgroundImage.png"];
    [pngData writeToFile:filePath atomically:YES];
    
    UIBackgroundTaskIdentifier backgoundTask;
    backgoundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        [[UIApplication sharedApplication] endBackgroundTask:backgoundTask];
    }];
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self updatePFUserBackgroundImage:backgroundImage];
        [[UIApplication sharedApplication]endBackgroundTask:backgoundTask];
        
        
    });

}


+(StatusLaneUser *)user{
    
    NSData *userData = [self getValue:kStatusLaneUserKey];
    StatusLaneUser *user = (StatusLaneUser *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return user;
}

+(void)setUser:(StatusLaneUser *)user{
    
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [self putValue:userData forkey:kStatusLaneUserKey];
    
}

+(NSString *)password{
    
    KeychainItemWrapper *kc = [[KeychainItemWrapper alloc] initWithIdentifier:@"Status Lane" accessGroup:nil];
    return [kc objectForKey:(__bridge NSString *)kSecValueData];
}


+(void)setPassword:(NSString *)password{
    
    KeychainItemWrapper *kc = [[KeychainItemWrapper alloc]initWithIdentifier:@"Status Lane" accessGroup:nil];
    
    [kc setObject:password forKey:(__bridge NSString *)kSecValueData];
    
}


+(void)clearDefaults{
    
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    KeychainItemWrapper *kc = [[KeychainItemWrapper alloc]initWithIdentifier:@"Status Lane" accessGroup:nil];
    [kc resetKeychainItem];
    
    

}


+(void)putValue:(id)value forkey:(NSString *)key{
    
    if (value) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }
    else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(id)getValue:(NSString *)key{
    
    id returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return returnObject;
}



+(void)updatePFUserColoum:(NSString *)column withInfo:(NSString *)info{
    
    NSLog(@"Attepmt update user");
    PFUser *currentUser = [PFUser currentUser];
    currentUser[column] = info;
    [currentUser saveInBackground];
    
}

+(void)updatePFUserProfileImage:(UIImage *)profileImage{
    
    if ([UIImage isImageToLarge:profileImage]) {
        
        profileImage = [UIImage shrinkImage:profileImage];
        
    }
    
    NSData *profileImageData = UIImagePNGRepresentation(profileImage);
    PFFile *profileImageFile = [PFFile fileWithData:profileImageData];
    [profileImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    
        if (succeeded) {
            
            PFUser *user = [PFUser currentUser];
            [user setObject:profileImageFile forKey:@"userProfilePicture"];
            [user saveInBackgroundWithBlock:^(BOOL suceeded, NSError *error){
                
                if (succeeded) {
                    NSLog(@"Image uploaded");

                }
                
                else{
                    
                    NSLog(@"%@", [error userInfo]);
                }

            
            }];
            
        }
        
        else{
            
            NSLog(@"Error from saving file: %@", [error userInfo]);

        }
    
    }];
    
    
}

+(void)updatePFUserBackgroundImage:(UIImage *)backgroundImage{
    
    if ([UIImage isImageToLarge:backgroundImage]) {
        
        backgroundImage = [UIImage shrinkImage:backgroundImage];
        
    }


    NSData *backgroundImageData = UIImagePNGRepresentation(backgroundImage);
    PFFile *backgroundImageFile = [PFFile fileWithData:backgroundImageData];
    
    [backgroundImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            PFUser *user = [PFUser currentUser];
            [user setObject:backgroundImageFile forKey:@"userBackgroundPicture"];
            [user saveInBackgroundWithBlock:^(BOOL suceeded, NSError *error){
                
                if (succeeded) {
                    NSLog(@"Image uploaded");
                    
                }
                
                else{
                    
                    NSLog(@"%@", [error userInfo]);
                }
                
                
            }];
            
        }
        
        else{
            
            NSLog(@"Error from saving file: %@", [error userInfo]);
            
        }
        
    }];
    
    
}





















@end

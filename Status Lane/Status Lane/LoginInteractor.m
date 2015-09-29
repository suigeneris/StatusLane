//
//  LoginInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "LoginInteractor.h"
#import "CountryCode.h"
#import "Defaults.h"
#import "NetworkManager.h"
#import "NSString+StatusLane.h"

@interface LoginInteractor()

@property (nonatomic, strong) id <NetworkProvider> networkProvider;

@end

@implementation LoginInteractor

#pragma mark -Login Interactor Delegate

-(NSString *)requestCountryCode{
    
    CountryCode *code = [CountryCode sharedInstance];
    NSString *string = code.countryCode;
    return string;
    
}

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        _networkProvider = [NetworkManager new];
        
    }
    return _networkProvider;
}


-(void)attemptLoginWithUsername:(NSString *)username andPassword:(NSString *)password{
    
    
    [self.networkProvider loginWithUsername:username
                                andPassword:password
                                    success:^(id responseObject) {
                                        
                                        [self.presenter hideActivityView];
                                        
                                        PFUser *user = responseObject;
                                        [self updateUserDefaultsWithLoggedInUser:user];
                                        
                                    } failure:^(NSError *error) {
                                        
                                        [self.presenter hideActivityView];
                                        if (error.code == kPFErrorObjectNotFound) {
                                            
                                            [self.presenter showErrorViewWithErrorMessage:@"Please Check Your Phone Number and Password and Try again"];
                                        }
                                        
                                        else if(error.code == kPFErrorTimeout || error.code == kPFErrorConnectionFailed){
                                            
                                            [self.presenter showErrorViewWithErrorMessage:@"Cannot Connect To Servers, Please check your Internet Connection"];
                                            
                                        }
                                        else{
                                            
                                            [self.presenter showErrorViewWithErrorMessage:@"Please Check Your Phone Number and Password and Try again"];
                                        }
                                    }];
    
    [self.presenter showActivityView];

    
}

-(void)loginCachedUser{
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        [self updateUserDefaultsWithLoggedInUser:currentUser];

    } else {
        
    }
}


#pragma mark - Interanl Methods

-(void)updateUserDefaultsWithLoggedInUser:(PFUser *)user{
    
    [Defaults setUsername:user.username];
    [Defaults setPassword:user.password];
    [Defaults setStatus:user[@"status"]];
    
    if (user[@"fullName"] && ![user[@"fullName"] isEqualToString:@"Full Name"]) {
        [Defaults setFullName:user[@"fullName"]];
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fullName"];
    }
    
    if (user[@"gender"] && ![user[@"gender"] isEqualToString:@"Gender not set"]) {
        [Defaults setSex:user[@"gender"]];
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sex"];
        
    }
    
    if (user.email) {
        [Defaults setEmailAddress:user.email];
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emailAddress"];
        
    }
    
    if (user[@"userBackgroundPicture"]) {
        
        [NSString deleteDocumentForName:@"backgroundImage.png"];
        PFFile *file = user[@"userBackgroundPicture"];
        [self downloadImageType:@"BackgroundPicture" fromPFFile:file];

    }
    else{
        
        [NSString deleteDocumentForName:@"backgroundImage.png"];

    }
    
    if (user[@"userProfilePicture"]) {
        
        [NSString deleteDocumentForName:@"profileImage.png"];
        PFFile *file = user[@"userProfilePicture"];
        [self downloadImageType:@"ProfilePicture" fromPFFile:file];

    }
    else{
        
        [NSString deleteDocumentForName:@"profileImage.png"];

    }
    
    if ([user[@"partner"] count] > 0) {
        
        NSArray *array = user[@"partner"];
        PFQuery *query;
        if ([[array objectAtIndex:0] isKindOfClass:NSClassFromString(@"PFUser")]){
            
            PFUser *partnerForUser = [array objectAtIndex:0];
            query = [PFUser query];
            [query whereKey:@"objectId" equalTo:partnerForUser.objectId];
        
        }
        else{
            
            PFObject *partnerForUser = [array objectAtIndex:0];
            query = [PFQuery queryWithClassName:@"AnonymousUser"];
            [query whereKey:@"objectId" equalTo:partnerForUser.objectId];
            
        }
        
        [self.networkProvider queryDatabaseWithQuery:query
                                             success:^(id responseObject) {
                                                 
                                                 PFObject *object = [responseObject objectAtIndex:0];
                                                 [Defaults setPartnerFullName:object[@"fullName"]];
                                                 [self.presenter login];
 
                                             } failure:^(NSError *error) {
                                                 
                                                 NSLog(@"This is the error %@", error.localizedDescription);
                                             }];
        
        
    }
    else{
        
        [self.presenter login];
            
    }

}

-(void)downloadImageType:(NSString *)type fromPFFile:(PFFile *)file{
    
    [self.networkProvider downloadDataFromFile:file
                                       success:^(id responseObject) {
                                           
                                           NSData *data = responseObject;
                                           UIImage *image = [UIImage imageWithData:data];
                                           if ([type isEqualToString:@"BackgroundPicture"]) {
                                               
                                               [Defaults setBackgroundImage:image];
                                               
                                           }
                                           else{
                                               
                                               [Defaults setProfileImage:image];
                                           }
                                           
                                       } failure:^(NSError *error) {
                                           
                                           NSLog(@"This is the error %@", error.localizedDescription);

                                       }];
}


@end

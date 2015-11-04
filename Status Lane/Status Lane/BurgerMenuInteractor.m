//
//  BurgerMenuInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "BurgerMenuInteractor.h"
#import "Defaults.h"
#import <Parse/Parse.h>

@implementation BurgerMenuInteractor


#pragma mark - Interactor Delegate methods

-(UIImage *)retrieveProfileImageFromFile{
    
    UIImage *image = [Defaults profileImage];
    
    if (image) {
        return image;
    }
    
    else{
        
        UIImage *image = [UIImage imageNamed:@"Default_Profile_Image"];
        return image;
    }
    
}

-(NSString *)getBadgeNumber{
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSInteger number = currentInstallation.badge;
    
    NSString *badgeNumber = [NSString stringWithFormat:@"%ld", (long)number];
    return badgeNumber;
    
}


@end

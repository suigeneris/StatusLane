//
//  BurgerMenuInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 06/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "BurgerMenuInteractor.h"
#import "Defaults.h"

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


@end

//
//  CountryCode.m
//  Status Lane
//
//  Created by Jonathan Aguele on 28/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "CountryCode.h"

@interface CountryCode ()

@end

@implementation CountryCode

+(instancetype)sharedInstance {
    
    static CountryCode *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[CountryCode alloc]init];
        
    });
    return sharedInstance;
}

@end

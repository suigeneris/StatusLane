//
//  CountryCode.h
//  Status Lane
//
//  Created by Jonathan Aguele on 28/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryCode : NSObject
@property (nonatomic, strong) NSString *countryCode;

+(instancetype)sharedInstance;
@end

//
//  SearchedUser.h
//  Status Lane
//
//  Created by Jonathan Aguele on 23/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SearchedUser : NSObject
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) UIImage *profileImage;
@end

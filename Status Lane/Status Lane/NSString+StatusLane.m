//
//  NSString+StatusLane.m
//  Status Lane
//
//  Created by Jonathan Aguele on 14/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "NSString+StatusLane.h"

@implementation NSString (StatusLane)

+(NSString *)documentsPathForFileName:(NSString *)name{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    return [documentPath stringByAppendingPathComponent:name];
}
@end

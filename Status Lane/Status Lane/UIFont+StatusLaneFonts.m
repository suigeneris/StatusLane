//
//  UIFont+StatusLaneFonts.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "UIFont+StatusLaneFonts.h"

@implementation UIFont (StatusLaneFonts)

+(UIFont  *)statusLaneAsapRegular:(CGFloat)ofSize{
    
    UIFont *font = [UIFont fontWithName:@"Asap-Regular" size:ofSize];
    return font;
    
}
+(UIFont  *)statusLaneAsapBold:(CGFloat)ofSize{
    
    UIFont *font = [UIFont fontWithName:@"Asap-Bold" size:ofSize];
    return font;

}

@end

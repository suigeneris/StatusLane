//
//  UIColor+StatusLane.m
//  Status Lane
//
//  Created by Jonathan Aguele on 27/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "UIColor+StatusLane.h"

@implementation UIColor (StatusLane)

+(UIColor *)statusLaneGreen {
    
    UIColor *statusLaneGreen = [UIColor colorWithRed:85.0f/255.0f
                                               green:193.0/255.0f
                                                blue:184.0/255.0f
                                               alpha:1
     ];
    
    return statusLaneGreen;
}

+(UIColor *)statusLaneGreenPressed{
    
    UIColor *statusLaneGreenPressed = [UIColor colorWithRed:62.0f/255.0f
                                               green:143.0/255.0f
                                                blue:136.0/255.0f
                                               alpha:1
                                ];
    
    return statusLaneGreenPressed;
}


+(UIColor *)statusLaneRed{
    
    UIColor *statusLaneRed = [UIColor colorWithRed:236.0f/255.0f
                                             green:110.0f/255.0f
                                              blue:110.0f/255.0f
                                             alpha:1
                              ];
    
    return statusLaneRed;
}

+(UIColor *)statusLaneRedPressed{
    
    UIColor *statusLaneRedPressed = [UIColor colorWithRed:172.0f/255.0f
                                                    green:80.0f/255.0f
                                                     blue:80.0f/255.0f
                                                    alpha:1
                                     ];
    
    return statusLaneRedPressed;
}

@end

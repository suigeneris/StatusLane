//
//  StatusLaneButtonGreen.m
//  Status Lane
//
//  Created by Jonathan Aguele on 20/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "StatusLaneButtonGreen.h"
#import "UIColor+StatusLane.h"

@implementation StatusLaneButtonGreen

-(void)setHighlighted:(BOOL)highlighted{
    
        [super setHighlighted:highlighted];
    
        if (highlighted) {
    
            self.backgroundColor = [UIColor statusLaneGreenPressed];
        }
    
        else{
    
            self.backgroundColor = [UIColor statusLaneGreen];
        }
}

@end

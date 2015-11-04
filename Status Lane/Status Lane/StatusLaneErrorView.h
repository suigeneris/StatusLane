//
//  StatusLaneErrorView.h
//  Status Lane
//
//  Created by Jonathan Aguele on 20/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusLaneErrorView : UIView


-(id)initWithMessage:(NSString *)message color:(UIColor *)color andTitle:(NSString *)title;
-(void)showWithCompletionBlock:(void(^)(void))completionBlock;
@end

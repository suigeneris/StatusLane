//
//  ReferAFriendPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ReferAFriendPresenter.h"

@interface ReferAFriendPresenter()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *navigationView;

@end
@implementation ReferAFriendPresenter

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUPUIElements];
    
    
}

-(void)setUPUIElements{
    
    self.navigationView.backgroundColor = [UIColor colorWithRed:0
                                                          green:0
                                                           blue:0
                                                          alpha:0.3
                                           ];
}

@end

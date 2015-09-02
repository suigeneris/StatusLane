//
//  StatusLaneErrorView.m
//  Status Lane
//
//  Created by Jonathan Aguele on 20/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "StatusLaneErrorView.h"
#import "UIFont+StatusLaneFonts.h"
#import "AppDelegate.h"
#import "UIColor+StatusLane.h"
#import "UIFont+StatusLaneFonts.h"

static const CGFloat animationDuration = 0.35f;

@interface StatusLaneErrorView()

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *message;
@property (nonatomic) UIButton *dismissButton;
@property (nonatomic) UIView *backGroundView;
@property (nonatomic) UILabel *errorLabel;
@property (nonatomic) UILabel *messageLabel;


@end


@implementation StatusLaneErrorView

-(id)initWithMessage:(NSString *)message {
    
    self = [super init];
    if (self) {
        self.message = message;
    }
    
    return self;
}

-(UIView *)backGroundView{
    
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]init];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_backGroundView addGestureRecognizer:tapGesture];
    }
    return _backGroundView;
}

-(UIButton *)dismissButton{
    
    if (!_dismissButton) {
        
        _dismissButton = [[UIButton alloc]init];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"DISMISS"];
        [string addAttribute:NSFontAttributeName value:[UIFont statusLaneAsapBold:16] range:NSMakeRange(0, [string length])];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [string length])];
        
        _dismissButton.backgroundColor = [UIColor clearColor];
        [_dismissButton setAttributedTitle:string forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
        _dismissButton.frame = CGRectMake((CGRectGetWidth(self.bounds)/2) - 25, CGRectGetHeight(self.bounds) - 100, 100, 50);
        [_dismissButton sizeToFit];
    }
    
    return _dismissButton;
}

-(UILabel *)errorLabel{
    
    if (!_errorLabel) {
        
        _errorLabel = [[UILabel alloc]init];
        _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _errorLabel.text = @"OOOOPs!";
        _errorLabel.textColor = [UIColor statusLaneRed];
        _errorLabel.font = [UIFont statusLaneAsapRegular:18];
        [_errorLabel sizeToFit];
    }
    
    return _errorLabel;
}

-(UILabel *)messageLabel{
    
    if (!_messageLabel) {
        
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _messageLabel.text = self.message;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor statusLaneRed];
        _messageLabel.font = [UIFont statusLaneAsapRegular:18];
    }
    
    return _messageLabel;
}
-(void)layoutSubviews{
    
    if (!self.backGroundView.superview) {
        [self addSubview:self.backGroundView];
    }
    [self.backGroundView setFrame:self.superview.bounds];
    [self.backGroundView addSubview:self.dismissButton];
    [self.backGroundView addSubview:self.errorLabel];
    [self.backGroundView addSubview:self.messageLabel];

    
    NSLayoutConstraint *errorLabelCenter = [NSLayoutConstraint constraintWithItem:self.errorLabel
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.backGroundView
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0
                                  ];
    
    NSLayoutConstraint *errorLabelBottom = [NSLayoutConstraint constraintWithItem:self.errorLabel
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.messageLabel
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:-20
                                  ];
    
    NSLayoutConstraint *messageLabelCenterX = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.backGroundView
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0
                                  ];
    
    NSLayoutConstraint *messageLabelCenterY = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.backGroundView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0
                                   ];
    
    NSLayoutConstraint *messageWidth = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.backGroundView
                                                                           attribute:NSLayoutAttributeWidth
                                                                          multiplier:0
                                                                            constant:+260
                                               ];
    
    [self.backGroundView addConstraint:errorLabelCenter];
    [self.backGroundView addConstraint:errorLabelBottom];
    [self.backGroundView addConstraint:messageLabelCenterX];
    [self.backGroundView addConstraint:messageLabelCenterY];
    [self.backGroundView addConstraint:messageWidth];

    [super layoutSubviews];
    
}

-(void)show{

    [self show:YES];
}

-(void)show:(BOOL)animated{
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.frame = app.window.bounds;
    self.alpha = 0.0;
    [app.window addSubview:self];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         self.alpha = 1;
                     }];
}


-(void)hide{
    
    [self hide:YES];
}


-(void)hide:(BOOL)animated{
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         self.alpha = 0.0f;
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
}























@end

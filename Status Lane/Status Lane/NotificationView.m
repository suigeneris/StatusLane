//
//  NotificationView.m
//  Status Lane
//
//  Created by Jonathan Aguele on 03/08/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "NotificationView.h"
#import "NetworkManager.h"
#import "AppDelegate.h"
#import "UIColor+StatusLane.h"
#import "UIFont+StatusLaneFonts.h"
#import "NSString+StatusLane.h"
#import "SWRevealViewController.h"
#import <ParseUI/ParseUI.h>

static const CGFloat animationDuration = 0.35f;

@interface NotificationView()

@property (nonatomic, strong) NSDictionary *notificationDictionary;
@property (nonatomic, strong) id <NetworkProvider> networkProvider;
@property (nonatomic, strong) PFUser *returnedUser;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) PFImageView *profileImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *xButton;

@end

@implementation NotificationView


-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    if (self) {
        
        self.notificationDictionary = dictionary;
        
    }
    return self;
    
}

-(UIView *)backgroundView{
    
    if (!_backgroundView) {
        
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, -70, self.frame.size.width, 70)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.99];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openRequests)];
        [_backgroundView addGestureRecognizer:tapGesture];
    }
    
    return _backgroundView;
}

-(PFImageView *)profileImageView{
    
    if (!_profileImageView) {
        
        _profileImageView = [[PFImageView alloc]initWithFrame:CGRectMake(10, 20, 35, 35)];
        _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width/2;
        _profileImageView.clipsToBounds = YES;
        
        if (self.returnedUser[@"userProfilePicture"]) {
            
            _profileImageView.file = self.returnedUser[@"userProfilePicture"];
            [_profileImageView loadInBackground];
        }
        else{
            
            _profileImageView.image = [UIImage imageNamed:@"Default_Profile_Image"];
        }
        
    }
    
    return _profileImageView;
}

-(UILabel *)messageLabel{
    
    if (!_messageLabel) {
        
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, 100, 20)];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont statusLaneAsapRegular:13];
        _messageLabel.text = [[self.notificationDictionary objectForKey:@"aps"] objectForKey:@"alert"];
        [_messageLabel sizeToFit];

    }
    
    return _messageLabel;
}

-(UILabel *)nameLabel{
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 100, 20)];
        _nameLabel.textColor = [UIColor statusLaneGreen];
        _nameLabel.font = [UIFont statusLaneAsapRegular:13];
        _nameLabel.text = self.returnedUser[@"fullName"];
        [_nameLabel sizeToFit];

    }
    return _nameLabel;
}

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        
        _networkProvider = [NetworkManager new];
    }
    return _networkProvider;
}

-(UIButton *)xButton{
    
    if (!_xButton) {
        
        _xButton = [[UIButton alloc]initWithFrame:CGRectMake(self.backgroundView.frame.size.width - 40, 25, 30, 30)];
        [_xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
        [_xButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];

    }
    return _xButton;
}

-(void)layoutSubviews{
    
    if (!self.backgroundView.superview) {
        [self addSubview:self.backgroundView];
    }

    [self.backgroundView addSubview:self.profileImageView];
    [self.backgroundView addSubview:self.messageLabel];
    [self.backgroundView addSubview:self.nameLabel];
    [self.backgroundView addSubview:self.xButton];
    
    [super layoutSubviews];
}

-(void)openRequests{
    

    SWRevealViewController *revealViewController = [[SWRevealViewController alloc]init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"Pending Requests"];
    UIViewController *rearViewController = [storyboard instantiateViewControllerWithIdentifier:@"Burger Menu"];
    UIViewController *rightViewController = [storyboard instantiateViewControllerWithIdentifier:@"Search Users"];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:rightViewController];
    navigationController.navigationBar.hidden = YES;

    revealViewController.frontViewController = frontViewController;
    revealViewController.rearViewController = rearViewController;
    revealViewController.rightViewController = navigationController;

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window setRootViewController:revealViewController];

    
}


-(void)getMetaData{
    NSString *objectId = [self.notificationDictionary objectForKey:@"objectId"];
    PFQuery *query = [PFUser query];
    [query  whereKey:@"objectId" equalTo:objectId];
    
    [self.networkProvider  queryDatabaseWithQuery:query
                                          success:^(id responseObject) {
                                             
                                              NSArray *array = responseObject;
                                              [self extractUserObjectReturnedFromQuery:array];
                                              [self show];
                                              
                                          } failure:^(NSError *error) {
                                              
                                              NSLog(@"Query failed with error: %@", error);
                                          }];
    
    
}

-(void)extractUserObjectReturnedFromQuery:(NSArray *)array{
    
    if (array) {
        
        self.returnedUser = [array objectAtIndex:0];
        
    }
    
}

-(void)show{
    
    [self show:YES];
}

-(void)show:(BOOL)animated{
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.frame = CGRectMake(0, 0, app.window.frame.size.width, 80);
    self.alpha = 0.0;
    
    [app.window addSubview:self];
    
    CGRect newBackgroundViewFrame = CGRectMake(0, 0, self.frame.size.width, 70);
    CGRect revertFrame = CGRectMake(0, -70, self.frame.size.width, 70);


    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         self.alpha = 1;

                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.35
                                          animations:^{
                                             
                                              self.backgroundView.frame = newBackgroundViewFrame;
                                          } completion:^(BOOL finished) {
                                              
                                              
                                              [UIView animateWithDuration:0.35
                                                                    delay:4
                                                                  options:UIViewAnimationOptionAllowUserInteraction
                                                               animations:^{
                                                                   
                                                                   self.backgroundView.frame = revertFrame;
                                                               } completion:^(BOOL finished){
                                                               
                                                                   [self hide];
                                                                   
                                                               }];
                                          }];
                         
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    for (UIView  *subview in self.backgroundView.subviews)
    {
        if ([subview.layer.presentationLayer hitTest:touchLocation])
        {
            if ([subview isKindOfClass:NSClassFromString(@"UIButton")]) {
                [self hide];
            }
            
            else if ([subview isKindOfClass:NSClassFromString(@"UIView")]){
                
                [self openRequests];
            }
            break;
        }
    }
}




@end

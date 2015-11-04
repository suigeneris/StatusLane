//
//  ReferAFriendPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "ReferAFriendPresenter.h"
#import "ReferAFriendInteractor.h"
#import "SWRevealViewController.h"
#import "StatusLaneErrorView.h"
#import <Social/Social.h>
#import "UIColor+StatusLane.h"

@interface ReferAFriendPresenter()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenu;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation ReferAFriendPresenter

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUPUIElements];
    [self revealControllerSetUp];
    
}

-(id<ReferAFriendInteractor>)interactor{
    
    if (!_interactor) {
        
        ReferAFriendInteractor *interactor = [ReferAFriendInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
    
    }
    return _interactor;
}

-(void)setUPUIElements{
    
    self.navigationView.backgroundColor = [UIColor colorWithRed:0
                                                          green:0
                                                           blue:0
                                                          alpha:0.3
                                           ];
}

-(void)revealControllerSetUp{
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.burgerMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer: self.revealViewController.tapGestureRecognizer];
        [self.searchButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (IBAction)showEmail:(id)sender {

    if ([MFMailComposeViewController canSendMail]) {
        
        [self presentViewController:[self.interactor returnMailViewController] animated:YES completion:NULL];

    }

    else{
        
        [self presentErrorMessageWithString:@"Cannot Send Mail, please Check your Internet Connection" andTitle:@"OOOOPs!"];
    }
}

- (IBAction)showSMS:(id)sender {
    
    if ([MFMessageComposeViewController canSendText]) {
        
        [self presentViewController:[self.interactor returnSMSViewController] animated:YES completion:NULL];
        
    }
    
    else{
        
        NSLog(@"Cant send message at this");
        [self presentErrorMessageWithString:@"Cannot Send SMS, please Check with your service provider" andTitle:@"OOOOPs!"];
    }

}


- (IBAction)faceBookButtonPressed:(id)sender {
  
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://statuslane.co.uk"];
    content.imageURL = [NSURL URLWithString:@"https://www.statuslane.co.uk"];
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:self.interactor];
    

    
     
}

- (IBAction)twitterButtonPressed:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        
        SLComposeViewController *socialController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [socialController setInitialText:@"Refer Friend To Use Status Lane"];
        [socialController addImage:[UIImage imageNamed:@"AppIcon"]];
        [socialController addURL:[NSURL URLWithString:@"https://www.statuslane.co.uk"]];
        [self presentViewController:socialController animated:YES completion:nil];
    }
    
    else{
        
    }
}



#pragma Mark - Presenter Delegate

-(void)dismissMailComposer{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Internal Methods

-(void)presentErrorMessageWithString:(NSString *)errorMessage andTitle:(NSString *)title{
    
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:errorMessage color:[UIColor statusLaneRed] andTitle:title];
    [errorView showWithCompletionBlock:nil];
    
}

@end

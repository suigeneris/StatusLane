//
//  ForgotPasswordPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "StatusLaneButtonGreen.h"
#import "ForgotPasswordPresenter.h"
#import "ForgotPasswordInteractor.h"
#import "StatusLaneErrorView.h"
#import "NSString+StatusLane.h"
#import "UIColor+StatusLane.h"


static void *countryCodeContext = &countryCodeContext;

@interface ForgotPasswordPresenter ()

@property (weak, nonatomic) IBOutlet UIButton *countrycodeButton;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextfield;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *isInvalidLabel;
@property (weak, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (weak, nonatomic) IBOutlet StatusLaneButtonGreen *submitButton;
@end

@implementation ForgotPasswordPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUiElements];
    // Do any additional setup after loading the view.
    
}

-(void)dealloc{
    
    @try {
        
        [self.countryCodeButton removeObserver:self forKeyPath:@"text" context:countryCodeContext];
        
    }
    @catch (NSException * __unused exception) {
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self countryCodeButton];
    [self.mobileNumberTextfield addTarget:self action:@selector(validatePhoneNumber) forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id<ForgotPasswordInteractor>)interactor{
    
    if (!_interactor) {
        
        ForgotPasswordInteractor *interactor = [ForgotPasswordInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
        
    }
    return _interactor;
}

-(UIButton *)countryCodeButton{
    
    if (_countrycodeButton) {
        
        NSString *string = [self.interactor requestCountryCode];
        if (string == (id)[NSNull null] || string.length == 0 ) {
            
            [_countrycodeButton setTitle:@"+44" forState:UIControlStateNormal];
        }
        
        else{
            
            [_countrycodeButton setTitle:string forState:UIControlStateNormal];
        }
    }
    
    return _countrycodeButton;
}



#pragma mark - UI View Setup

-(void)setUpUiElements {
    
    self.countrycodeButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.backButton.transform = CGAffineTransformMakeRotation(-M_PI_2); //rotation in radians

    
    self.mobileNumberTextfield.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.mobileNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"mobile number" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString:self.forgotPasswordLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 6)];
    self.forgotPasswordLabel.attributedText = attrStr;
    
    [self.countryCodeButton.titleLabel addObserver:self
                                        forKeyPath:@"text"
                                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                           context:countryCodeContext];
    
}
- (IBAction)submitButtonPressed:(id)sender {
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self touchesBegan:nil withEvent:nil];
    [self.interactor queryUsernameFor:[self.countrycodeButton.titleLabel.text stringByAppendingString:self.mobileNumberTextfield.text]];
    
}
- (IBAction)backButtonPressed:(id)sender {
    
    [self touchesBegan:nil withEvent:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.mobileNumberTextfield resignFirstResponder];
    self.isInvalidLabel.hidden = YES;
}

#pragma mark - Presenter Delegate Methods

-(void)showErrorViewWithMessage:(NSString *)message{
    

    [self touchesBegan:nil withEvent:nil];
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:message];
    [errorView show];
}

-(void)dismissView{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}




#pragma marl - Internal Methods

-(void)validatePhoneNumber{
    
    
    if ([self isNumberInTextFieldValid]) {
        
        self.isInvalidLabel.hidden = YES;
        self.submitButton.backgroundColor = [UIColor statusLaneGreen];
        self.submitButton.userInteractionEnabled = YES;

    }
    
    else{
        
        self.isInvalidLabel.text = @"number invalid";
        self.isInvalidLabel.hidden = NO;
        self.submitButton.backgroundColor = [UIColor statusLaneGreenPressed];
        self.submitButton.userInteractionEnabled = NO;
    }
    
}

-(BOOL)isNumberInTextFieldValid{
    
    NSString *fullNumber = [self.countryCodeButton.titleLabel.text stringByAppendingString:self.mobileNumberTextfield.text];
    BOOL isNumberValid = [NSString isPhoneNumberValid:fullNumber];
    return isNumberValid;
    
}

#pragma mark - Key Value Observer

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if (context == countryCodeContext)
    {
        if ([[change objectForKey:@"new"] isEqualToString:[change objectForKey:@"old"]] ) {
            
        }
        
        else{
            
            [self validatePhoneNumber];
            
        }
    }
    
}



@end
















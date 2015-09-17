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


@interface ForgotPasswordPresenter ()

@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextfield;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
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
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    

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



#pragma mark - UI View Setup

-(void)setUpUiElements {
    
    self.backButton.transform = CGAffineTransformMakeRotation(-M_PI_2); //rotation in radians

    
    self.mobileNumberTextfield.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    self.mobileNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"email" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString:self.forgotPasswordLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 6)];
    self.forgotPasswordLabel.attributedText = attrStr;
    
    
}
- (IBAction)submitButtonPressed:(id)sender {
    
    [self touchesBegan:nil withEvent:nil];
    
    if ([self.mobileNumberTextfield.text isValidEmail]) {
        
        [self.interactor resetPasswordForEmail:self.mobileNumberTextfield.text];
    }
    
    else{
        
        [self showErrorViewWithMessage:@"Please Enter A Valid Email" andTitle:@"OOOOPs!"];
    }

    
}
- (IBAction)backButtonPressed:(id)sender {
    
    [self touchesBegan:nil withEvent:nil];
    [self dismissView];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.mobileNumberTextfield resignFirstResponder];
}

#pragma mark - Presenter Delegate Methods

-(void)showErrorViewWithMessage:(NSString *)message andTitle:(NSString *)title{
    

    [self touchesBegan:nil withEvent:nil];
    StatusLaneErrorView *errorView = [[StatusLaneErrorView alloc]initWithMessage:message andTitle:title];
    [errorView show];
}

-(void)dismissView{

    [self dismissViewControllerAnimated:YES completion:nil];

}




#pragma marl - Internal Methods








@end
















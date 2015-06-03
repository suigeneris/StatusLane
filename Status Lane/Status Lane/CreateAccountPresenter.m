//
//  CreateAccountPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 14/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "CreateAccountPresenter.h"
#import "CreateAccountInteractor.h"

@interface CreateAccountPresenter ()
    
@property (weak, nonatomic) IBOutlet UILabel *statusLaneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;

@end

@implementation CreateAccountPresenter
    


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setAttributesForUILabel];
    
   
}

-(void)viewWillAppear:(BOOL)animated{

    [self countryCodeButton];
    
}

-(id<CreateAccountInteractor>)interactor{
    
    if (!_interactor) {
        
        _interactor = [CreateAccountInteractor new];
    }
    
    return _interactor;
    
}

-(UIButton *)countryCodeButton{

    if (_countryCodeButton) {
        
        NSString *string = [self.interactor requestCountryCode];

        if (string == (id)[NSNull null] || string.length == 0 ) {

            [_countryCodeButton setTitle:@"+44" forState:UIControlStateNormal];
        }
        
        else{

            [_countryCodeButton setTitle:string forState:UIControlStateNormal];
        }
    }
    
    return _countryCodeButton;
}
#pragma mark - Additional UI setup

- (void)setAttributesForUILabel {
    

    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString:self.statusLaneLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 6)];
    self.statusLaneLabel.attributedText = attrStr;
    

    self.phoneNumberTextfield.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.09];
    self.phoneNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"mobile number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.countryCodeButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.09];

}

- (IBAction)continueButtonPressed:(id)sender {
}

- (IBAction)alreadyAuser:(id)sender {
}

#pragma mark - Internal Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.phoneNumberTextfield resignFirstResponder];
}


@end

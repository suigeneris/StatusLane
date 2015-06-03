//
//  HomePagePresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 20/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "HomePagePresenter.h"
#import "HomePageInteractor.h"
#import "UIFont+StatusLaneFonts.h"
#import "UIColor+StatusLane.h"

@interface HomePagePresenter ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomUIView;
@property (weak, nonatomic) IBOutlet UILabel *relationshipStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation HomePagePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self additionalUIViewSetup];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImagePickerController *)imagePicker{
    
    if (!_imagePicker) {
        
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self.interactor;
        _imagePicker.allowsEditing = NO;
        
    }
    
    return _imagePicker;
}

-(id<HomePageInteractorDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>)interactor{
    
    if (!_interactor) {
        HomePageInteractor *interactor = [HomePageInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
    }
    return _interactor;
}

-(void)additionalUIViewSetup{
    
    [self.bottomUIView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    
    NSLayoutConstraint *buttomUIViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.bottomUIView
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.view
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                   multiplier:0.30
                                                                                     constant:0
                                                        ];
    [self.view addConstraint:buttomUIViewHeightConstraint];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBOutlets

- (IBAction)pressedChangeBackgroundImageButton:(id)sender {
    
    [self showChooseImageActionSheet];
}


- (IBAction)relationshipStatusPressed:(id)sender {
    
}

- (IBAction)addProfileImagePressed:(UITapGestureRecognizer *)sender {
    
    [self showChooseImageActionSheet];
}



#pragma mark - Internal Methods

-(void)showChooseImageActionSheet {
    
    UIAlertController *chooseImageActionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                                       message:nil
                                                                                preferredStyle:UIAlertControllerStyleActionSheet
                                                        
                                                    ];
    

    
    [chooseImageActionSheet addAction:[UIAlertAction actionWithTitle:@"Take A Picture"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                
                                                                if ([self.interactor checkImagePickerSourceTypeAvailability:[self class]]) {
                                                                    
                                                                    [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                                                                }
                                                                
                                                                else{
                                                                    
                                                                    [self showAlertWithTitle:@"Error"
                                                                                errorMessage:@"Device Has No Camera"
                                                                              actionTitle:@"Ok"
                                                                     withStyle:UIAlertControllerStyleAlert
                                                                                   withBlock:nil];

                                                                }
            
                                                            }]];
    
    [chooseImageActionSheet addAction:[UIAlertAction actionWithTitle:@"Select From Photos"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                                 [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                                 
                                                             }]];
    
    [chooseImageActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                             }]];
    
    
    [self presentViewController:chooseImageActionSheet animated:YES completion:nil];
                                                   
    
}



#pragma mark - Presenter Delegate Methods

-(void)showAlertWithTitle:(NSString *)title errorMessage:(NSString *)error actionTitle:(NSString *)actionTitle withStyle:(UIAlertControllerStyle)style withBlock:(AlertControllerBlock)alertViewBlock{
    
    UIAlertController *noCamera = [UIAlertController alertControllerWithTitle:title
                                                                      message:error
                                                               preferredStyle:style
                                   ];
    
    [noCamera addAction:[UIAlertAction actionWithTitle:actionTitle
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction *action) {
                                                  
                                                  if (alertViewBlock) {
                                                      alertViewBlock();
                                                  }
                                                  
                                                  else{
                                                  }
                                                  
                                              }]];
    
    [self presentViewController:noCamera animated:YES completion:nil];
    
    
}

-(void)dissmiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setBackGroundImage:(UIImage *)image{
    
    self.backgroundImageView.image = image;
}

#pragma mark - Internal Methods

-(void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    
    self.imagePicker.sourceType = sourceType;
    [self presentViewController:_imagePicker animated:YES completion:^{
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *accessGranted = [self.interactor checkAuthorizationForSourceType:sourceType];

            if ([accessGranted isEqualToString:@"Authorised"]) {

                
            }
            
            else  if ([accessGranted isEqualToString:@"Denied"] || [accessGranted isEqualToString:@"Restricted"]) {

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                               message:sourceType ? @"We need Access to camera" : @"We need access to photos"
                                                                        preferredStyle:UIAlertControllerStyleAlert
                                            
                                            ];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            
                                                            [self.interactor openSettings];
                                                            
                                                        }]];
                
                dispatch_async( dispatch_get_main_queue(), ^{
                    
                    [_imagePicker presentViewController:alert animated:YES completion:nil];

                });
                
            }
            
            else if ([accessGranted isEqualToString:@"Not Determined"]){
                
            }
            


            
        });
        
    }];
    
    
}

@end

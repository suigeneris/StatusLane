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
#import "SWRevealViewController.h"
#import "StatusListPresenter.h"

@interface HomePagePresenter ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomUIView;
@property (weak, nonatomic) IBOutlet UILabel *relationshipStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIButton *burgerMenu;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation HomePagePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self additionalUIViewSetup];
    [self revealControllerSetUp];
    
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
    [self.profileImage.layer setCornerRadius:_profileImage.frame.size.width/2];
    [self.profileImage.layer setMasksToBounds:YES];
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"popOver"]) {
        
        UINavigationController *destNav = segue.destinationViewController;
        StatusListPresenter *vc = destNav.viewControllers.firstObject;
        
        // This is the important part
        UIPopoverPresentationController *popPC = vc.popoverPresentationController;
        popPC.delegate = self;
    
    }
}

#pragma mark - IBOutlets

- (IBAction)pressedChangeBackgroundImageButton:(id)sender {
    
    [self showChooseImageActionSheet:0];
}


- (IBAction)relationshipStatusPressed:(id)sender {
    
}

- (IBAction)addProfileImagePressed:(UITapGestureRecognizer *)sender {
    
    [self showChooseImageActionSheet:1];
}


#pragma mark - Internal Methods

-(void)showChooseImageActionSheet:(int) sender {
    
    UIAlertController *chooseImageActionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                                       message:nil
                                                                                preferredStyle:UIAlertControllerStyleActionSheet
                                                        
                                                    ];
    

    
    [chooseImageActionSheet addAction:[UIAlertAction actionWithTitle:@"Take A Picture"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                
                                                                if ([self.interactor checkImagePickerSourceTypeAvailability:[self class]]) {
                                                                    
                                                                    [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera from:sender];
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
                                                                 
                                                                 [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary from:sender];
                                                                 
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

-(void)dissmissImageCropper{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setBackGroundImage:(UIImage *)image{
    
    self.backgroundImageView.image = image;

}

-(void)chooseProfileImage:(UIImage *)profileImage{
    
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImage.layer.borderWidth = 3;
    [self.profileImage setImage:profileImage];
}


-(void)showImageCropper:(UIImage *)image{
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self.interactor;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}


#pragma mark - Internal Methods

-(void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType from:(int)alertViewFrom{
    
    self.imagePicker.sourceType = sourceType;
    NSString *accessGranted = [self.interactor checkAuthorizationForSourceType:sourceType];

    [self.interactor setFlagForAlertViewButtonPressed:alertViewFrom];

    [self presentViewController:_imagePicker animated:YES completion:^{
        
        if ([accessGranted isEqualToString:@"Authorised"]) {
            
        }
        
        else if ([accessGranted isEqualToString:@"Denied"] || [accessGranted isEqualToString:@"Restricted"]) {
            
            [_imagePicker presentViewController:[self alertViewForImagePickerFromSourceType:sourceType] animated:YES completion:nil];
            
        }
        
        else if ([accessGranted isEqualToString:@"Not Determined"]){
            
        }
        
    }];
    
}

-(UIAlertController *)alertViewForImagePickerFromSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:sourceType ? @"We need Access to camera" : @"We need access to photos"
                                                            preferredStyle:UIAlertControllerStyleAlert
                                
                                ];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                
                                                [self.interactor openSettings];
                                                
                                            }]];
    
    return alert;
    
    
}

#pragma mark - UIPopOverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

















@end

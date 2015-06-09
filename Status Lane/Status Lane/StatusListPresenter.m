//
//  StatusListPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 08/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "StatusListPresenter.h"
#import "StatusListInteractor.h"

@interface StatusListPresenter()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation StatusListPresenter

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.tableView.delegate = self.interactor;
    self.tableView.dataSource = [self.interactor dataSource];

}



-(void)awakeFromNib {
    
    [super awakeFromNib];
}

-(id<StatusListInteractorDelegate, StatusListInteractorDataSource, UITableViewDelegate>)interactor{
    
    if (!_interactor) {
        
        StatusListInteractor *interactor = [StatusListInteractor new];
        interactor.presenter = self;
        _interactor = interactor;
    }
    
    return _interactor;
}

#pragma mark Status List Presenter

-(void)dismissView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end

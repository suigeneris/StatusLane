//
//  SettingsPresenter.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "SettingsPresenter.h"
#import "SettingsInteractor.h"

@interface SettingsPresenter()

@end


@implementation SettingsPresenter

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.tableView.delegate = self.interactor;
    self.tableView.dataSource = [self.interactor dataSource];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:1
                                                      green:1
                                                       blue:1
                                                      alpha:0.13
                                       ]];

}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    SettingsInteractor *interactor = [SettingsInteractor new];
    self.interactor = interactor;
}



@end

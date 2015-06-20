//
//  CountryListCell.h
//  Status Lane
//
//  Created by Jonathan Aguele on 27/05/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;

@end

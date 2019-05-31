//
//  L_NewBikeInfoBarcode3TableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeDeviceModel.h"

@interface L_NewBikeInfoBarcode3TableViewCell : UITableViewCell

@property (nonatomic, strong) L_BikeDeviceModel *deviceModel;

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeNumLabel;


@end

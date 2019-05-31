//
//  L_HouseDetailsFirstTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_HouseDetailModel.h"

@interface L_HouseDetailsFirstTVC : UITableViewCell

@property (nonatomic, strong) L_HouseDetailModel *model;

/**
 总价
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

/**
 每平米价钱
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/**
 浏览量
 */
@property (weak, nonatomic) IBOutlet UILabel *pvcountLabel;

/**
 发布日期
 */
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;

/**
 小区名称
 */
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;

@end

//
//  L_MoneyDetailTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BalanceListModel.h"

@interface L_MoneyDetailTVC : UITableViewCell

/**
 分页获得我的余额记录model
 */
@property (nonatomic, strong) L_BalanceListModel *model;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 消费
 */
@property (weak, nonatomic) IBOutlet UILabel *minusMoney;

@end

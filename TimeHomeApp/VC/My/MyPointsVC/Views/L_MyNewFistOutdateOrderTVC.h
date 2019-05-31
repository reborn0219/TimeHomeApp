//
//  L_MyNewFistOutdateOrderTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_ExchangeModel.h"

/**
 已失效券
 */
@interface L_MyNewFistOutdateOrderTVC : UITableViewCell

@property (nonatomic, strong) L_ExchangeModel *model;

/**
 图片宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageViewWidthLayoutConstraint;

/**
 商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftGoodImageView;

/**
 店家名称
 */
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

/**
 商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;

/**
 时间图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;

/**
 有效期
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 已过期
 */
@property (weak, nonatomic) IBOutlet UILabel *outdateLabel;

/**
 已使用图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *hasUseImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout3;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

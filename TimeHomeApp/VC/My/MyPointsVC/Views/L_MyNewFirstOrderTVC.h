//
//  L_MyNewFirstOrderTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_ExchangeModel.h"

typedef void(^GivenButtonDidTouchBlock)();

/**
 我的订单
 */
@interface L_MyNewFirstOrderTVC : UITableViewCell

@property (nonatomic, strong) L_ExchangeModel *model;

@property (nonatomic, copy) GivenButtonDidTouchBlock givenButtonDidTouchBlock;

/**
 左边图片宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageWidthLayoutConstraint;

/**
 图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftShopImageView;

/**
 即将过期
 */
@property (weak, nonatomic) IBOutlet UILabel *willOutdateLabel;

/**
 赠予按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *givenButton;

/**
 商家名称
 */
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

/**
 商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;

/**
 有效期
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 过期图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout3;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

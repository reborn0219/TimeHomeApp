//
//  L_ExchangeListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "L_ExchangeModel.h"

@interface L_ExchangeListTVC : UITableViewCell

/**
 0未使用 1已过期 2已使用 3已过期，已使用
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) L_ExchangeModel *model;

/**
 图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;

/**
 订单编号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/**
 有效期
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 已使用图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *hasUseImageView;

/**
 已过期
 */
@property (weak, nonatomic) IBOutlet UILabel *outDateLabel;

/**
 横线
 */
@property (weak, nonatomic) IBOutlet UIView *lineView1;

/**
 竖线
 */
@property (weak, nonatomic) IBOutlet UIView *lineView2;

/**
 图片宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoImageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UIView *topBgView;

@end

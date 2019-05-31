//
//  L_BikeManagerListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/23.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "L_BikeListModel.h"

typedef void(^AllButtonDidTouchBlock)(NSInteger buttonIndex);

@interface L_BikeManagerListTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandLabelLeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandLabelRightlayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLeftLabelLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomRightLabelLayout;

/**
 二轮车图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *bikeImageView;

/**
 图片左边约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftLayoutConstraint;

/**
 品牌名
 */
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;

/**
 下左label
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLabel;

/**
 下右label
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomRightLabel;

/**
 修改信息图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *motifyImageView;

/**
 锁定状态图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *lockStateImageView;

/**
 修改信息label
 */
@property (weak, nonatomic) IBOutlet UILabel *motifyLabel;

/**
 锁定状态label
 */
@property (weak, nonatomic) IBOutlet UILabel *lockStateLabel;

/**
 修改信息背景view
 */
@property (weak, nonatomic) IBOutlet UIView *motifyBgView;

/**
 锁定状态背景view
 */
@property (weak, nonatomic) IBOutlet UIView *lockStateBgView;

/**
 添加感应条背景view
 */
@property (weak, nonatomic) IBOutlet UIView *addBgView;

/**
 点击进入详情view
 */
@property (weak, nonatomic) IBOutlet UIView *infoBgView;


@property (nonatomic, strong) L_BikeListModel *bikeModel;

@property (nonatomic, copy) AllButtonDidTouchBlock allButtonDidTouchBlock;

@end

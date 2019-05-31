//
//  L_NormalDetailsFirstTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_NormalInfoModel.h"

typedef void(^AllButtonsDidTouchBlock)(NSInteger buttonIndex);

@interface L_NormalDetailsFirstTVC : UITableViewCell

@property (nonatomic, copy) AllButtonsDidTouchBlock allButtonsDidTouchBlock;

@property (nonatomic, strong) L_NormalInfoModel *model;

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 性别背景
 */
@property (weak, nonatomic) IBOutlet UIView *sexBgView;

/**
 性别图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *sexBgImageView;

/**
 年龄
 */
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 加关注
 */
@property (weak, nonatomic) IBOutlet UIButton *addAttentionButton;

@end

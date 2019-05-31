//
//  qusetionFirstTableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

typedef void(^AllButtonsDidTouchBlock)(NSInteger buttonIndex);

@interface qusetionFirstTableViewCell : UITableViewCell

@property (nonatomic, copy) AllButtonsDidTouchBlock allButtonsDidTouchBlock;

@property (nonatomic, strong) QuestionModel *model;

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

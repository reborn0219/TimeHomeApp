//
//  L_VertifyStateViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

/**
 认证状态
 */
@interface L_VertifyStateViewController : THBaseViewController

/**
 状态 1.添加家人，房产出租 2.家人列表，房产出租 3.重新认证 4.按钮隐藏 5.审核中
 */
@property (nonatomic, assign) NSInteger state;

/**
 图片名称
 */
@property (nonatomic, strong) NSString *stateImageName;

/**
 状态
 */
@property (nonatomic, strong) NSString *stateStr;

/**
 内容
 */
@property (nonatomic, strong) NSString *content;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@end

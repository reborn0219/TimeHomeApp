//
//  L_PeopleListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_MyFollowersModel.h"

typedef void(^HeadImageViewDidTouchBlock)();

typedef void(^AttentionButtonDidTouchBlock)();
/**
 用户列表
 */
@interface L_PeopleListTVC : UITableViewCell

@property (nonatomic, copy) HeadImageViewDidTouchBlock headImageViewDidTouchBlock;

/**
 我关注的用户model
 */
@property (nonatomic, strong) L_MyFollowersModel *model;

/**
 取消关注
 */
@property (nonatomic, copy) AttentionButtonDidTouchBlock attentionButtonDidTouchBlock;

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 性别背景
 */
@property (weak, nonatomic) IBOutlet UIView *sexBgView;

/**
 性别图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

/**
 年龄
 */
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

/**
 关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@end

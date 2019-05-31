//
//  L_NormalDetailCommentTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/9.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_TieziCommentModel.h"

typedef void(^AllButtonDidTouchBlock)(NSInteger buttonIndex);
@interface L_NormalDetailCommentTVC : UITableViewCell

/**
 type == 1 普通评论 type == 2 回复评论
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) L_TieziCommentModel *model;

@property (nonatomic, copy) AllButtonDidTouchBlock allButtonDidTouchBlock;

/**
 头像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 评论数
 */
@property (weak, nonatomic) IBOutlet UILabel *commentCountsLabel;

/**
 评论内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/**
 评论图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;

@end

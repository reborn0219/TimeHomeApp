//
//  L_myCommentsTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LXModel.h"
#import "L_UserCommentModel.h"

typedef void(^DeleteButtonTouchBlock)();
typedef void(^ReloadIndexPathBlock)();
/**
 我的评论
 */
@interface L_myCommentsTVC : UITableViewCell

/**
 左边图片宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageWidthConstraint;

/**
 左面图片高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageHeightConstraint;

/**
 左面图片向上距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageTopConstraint;

/**
 帖子标题距左边图片距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelLeftConstraint;

/**
 删除回调
 */
@property (nonatomic, copy) DeleteButtonTouchBlock deleteButtonTouchBlock;

/**
 刷新回调
 */
@property (nonatomic, copy) ReloadIndexPathBlock reloadIndexPathBlock;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 显示全部按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *showAllButton;

/**
 左边图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

/**
 具体物品标题
 */
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 删除按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) L_UserCommentModel *model;

@end

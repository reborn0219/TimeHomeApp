//
//  L_ShareActivityTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBSModel.h"

@interface L_ShareActivityTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContentHeight_Layout;


/**
 定位图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *dingwei_ImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dingweiImageView_WidthLayout;

/**
 本社区，图说中 传2
 */
@property (nonatomic, assign) NSInteger cellType;

/**
 点击回调
 */
@property (nonatomic, copy) ViewsEventBlock cellBtnDidClickBlock;

//活动分享帖包含一张图片的情况，高度228固定

@property (nonatomic, strong) BBSModel *model;

/**
 图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title_Label;

/**
 详细描述
 */
@property (weak, nonatomic) IBOutlet UILabel *detail_Label;

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *header_ImageView;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickName_Label;

/**
 点赞
 */
@property (weak, nonatomic) IBOutlet UILabel *dianzan_Label;

/**
 点赞图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *praise_ImageView;


/**
 社区名称
 */
@property (weak, nonatomic) IBOutlet UILabel *community_Label;

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *time_Label;

/**
 最底下分割线
 */
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

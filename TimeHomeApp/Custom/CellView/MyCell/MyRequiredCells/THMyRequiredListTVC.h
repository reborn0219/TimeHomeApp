//
//  THMyRequiredListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"
#import "UserReserveInfo.h"

@interface THMyRequiredListTVC : UITableViewCell
/**
 *  消息提示小红点
 */
@property (nonatomic, strong) UIImageView *infoImage;
/**
 *  报修model
 */
@property (nonatomic, strong) UserReserveInfo *model;
/**
 *  左边图片
 */
@property (nonatomic, strong) UIImageView *leftImageView;
/**
 *  上边label，此处为时间
 */
@property (nonatomic, strong) UILabel *topDetailLabel;
/**
 *  下方标题label
 */
@property (nonatomic, strong) UILabel *bottomTitleLabel;
/**
 *  右边标题label
 */
@property (nonatomic, strong) UILabel *rightDetailLabel;


@end

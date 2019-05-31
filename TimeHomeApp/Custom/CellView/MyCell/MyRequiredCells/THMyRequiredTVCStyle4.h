//
//  THMyRequiredTVCStyle4.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的报修自定义cell4
 */
#import "THABaseTableViewCell.h"
#import "UserReserveLog.h"
#import "UserReserveInfo.h"

@interface THMyRequiredTVCStyle4 : THABaseTableViewCell

/**
 *  状态跟踪的时间label
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *  状态跟踪的具体内容label
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  报修跟踪model
 */
@property (nonatomic, strong) UserReserveLog *userInfo;
/**
 *  是否已评价
 */
@property (nonatomic, assign) BOOL isCompleted;

@property (nonatomic, strong) UserReserveInfo *model;

@end

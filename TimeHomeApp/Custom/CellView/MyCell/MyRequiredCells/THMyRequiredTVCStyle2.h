//
//  THMyRequiredTVCStyle2.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的报修自定义cell2
 */
#import "THABaseTableViewCell.h"

#import "UserReserveInfo.h"
#import "UserComplaint.h"

@interface THMyRequiredTVCStyle2 : THABaseTableViewCell
/**
 *  报修时间
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *  报修设施
 */
@property (nonatomic, strong) UILabel *deviceLabel;
/**
 *  价格
 */
@property (nonatomic, strong) UILabel *priceLabel;

/**
 *  预约时间
 */
@property (nonatomic, strong) UILabel *appointmentTimeLabel;
/**
 *  报修信息model
 */
@property (nonatomic, strong) UserReserveInfo *userInfo;
/**
 *  用户报修信息
 */
//@property (nonatomic, strong) UserReserveInfo *userInfo2;
/**
 *  投诉model
 */
@property (nonatomic, strong) UserComplaint *userComplaint2;


@end

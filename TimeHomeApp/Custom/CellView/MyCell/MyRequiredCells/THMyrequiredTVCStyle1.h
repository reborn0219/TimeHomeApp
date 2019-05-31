//
//  THMyrequiredTVCStyle1.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的报修自定义cell1
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return 
 */
#import "THABaseTableViewCell.h"

#import "UserReserveInfo.h"
#import "UserComplaint.h"

@interface THMyrequiredTVCStyle1 : THABaseTableViewCell
/**
 *  左边标题label
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  右边标题label
 */
@property (nonatomic, strong) UILabel *detailLabel;
/**
 *  右边颜色竖线
 */
@property (nonatomic, strong) UIView *lineView;

/**
 *  报修信息model
 */
@property (nonatomic, strong) UserReserveInfo *userInfo;
/**
 *  投诉信息model
 */
@property (nonatomic, strong) UserComplaint *userComplaint;
@property (nonatomic, strong) UserComplaint *userComplaint2;
@end

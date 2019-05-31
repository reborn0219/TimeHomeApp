//
//  THMyrequiredTVCPicStyle1.h
//  TimeHomeApp
//
//  Created by 世博 on 16/5/3.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"
#import "UserReserveInfo.h"
#import "UserReservePic.h"
#import "UserComplaint.h"
@interface THMyrequiredTVCPicStyle1 : THABaseTableViewCell
/**
 *  详细描述标题label
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  详细描述内容label
 */
@property (nonatomic, strong) UILabel *describeLabel;

/**
 *  报修信息model
 */
@property (nonatomic, strong) UserReserveInfo *userInfo;
/**
 *  投诉model
 */
@property (nonatomic, strong) UserComplaint *userComplaint2;
@end

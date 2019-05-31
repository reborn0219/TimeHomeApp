//
//  THMyActivityListTVC2.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"

#import "UserActivity.h"

@interface THMyActivityListTVC2 : THABaseTableViewCell

/**
 *  活动时间,1行
 */
@property (nonatomic, strong) UILabel *time_Label;
/**
 *  活动内容,2行
 */
@property (nonatomic, strong) UILabel *content_Label;

/**
 *  我的活动model
 */
@property (nonatomic, strong) UserActivity *userActivity;

@end

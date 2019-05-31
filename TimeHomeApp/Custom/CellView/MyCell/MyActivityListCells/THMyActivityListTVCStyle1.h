//
//  THMyActivityListTVCStyle1.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserActivity.h"
/**
 *  我的活动最新cell
 */
@interface THMyActivityListTVCStyle1 : UITableViewCell
/**
 *  活动图片
 */
@property (nonatomic, strong) UIImageView *activityImage;
/**
 *  活动标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  时间图片
 */
@property (nonatomic, strong) UIImageView *timeImage;
/**
 *  时间label
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *  过期图片
 */
@property (nonatomic, strong) UIImageView *outDateImage;
/**
 *  我的活动model
 */
@property (nonatomic, strong) UserActivity *userActivity;

@end

//
//  THMyPointsDetailsTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  在我的积分界面中使用过，样子为label+label+label
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import "THABaseTableViewCell.h"
#import "UserIntergralLog.h"

@interface THMyPointsDetailsTVC : THABaseTableViewCell
/**
 *  左边时间label
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *  中间内容label
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 *  右边加数label
 */
@property (nonatomic, strong) UILabel *addCountsLabel;
/**
 *  虚线，这里用来作为cell的分割线
 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
/**
 *  传递的model
 */
@property (nonatomic, strong) UserIntergralLog *model;

@end

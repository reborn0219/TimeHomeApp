//
//  THMyCurrentPointsTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  在我的积分界面中使用过
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import "THABaseTableViewCell.h"

@interface THMyCurrentPointsTVC : THABaseTableViewCell
/**
 *  左边头像
 */
@property (nonatomic, strong) UIImageView *headImageView;//
/**
 *  当前积分
 */
@property (nonatomic, strong) UILabel *currentPointsLabel;//

@end

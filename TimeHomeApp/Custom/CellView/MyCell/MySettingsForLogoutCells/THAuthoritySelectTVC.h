//
//  THAuthoritySelectTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  在车位授权和房产授权中使用过，带有共享，出租两种按钮的选择
 *
 *  @param buttonIndex
 *
 *  @return
 */
#import "THABaseTableViewCell.h"
#import "LXModel.h"

typedef void (^ SelectedButtonCallBack)(NSInteger buttonIndex);
@interface THAuthoritySelectTVC : THABaseTableViewCell
/**
 *  传递的数据模型
 */
@property (nonatomic, strong) LXModel *model;
/**
 *  两个按钮的点击事件返回block
 */
@property (nonatomic, strong) SelectedButtonCallBack selectedButtonCallBack;

@end

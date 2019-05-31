//
//  THMyInstructionsTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  在我的积分中使用过，主要样子为中间label，可随行数增加而增加高度
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import "THABaseTableViewCell.h"
#import "LXModel.h"

@interface THMyInstructionsTVC : THABaseTableViewCell
/**
 *  传递的model
 */
@property (nonatomic, strong) LXModel *model;

@end

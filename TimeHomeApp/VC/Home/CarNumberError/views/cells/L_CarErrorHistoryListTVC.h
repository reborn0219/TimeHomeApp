//
//  L_CarErrorHistoryListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_CarNumApplyListModel.h"

@interface L_CarErrorHistoryListTVC : UITableViewCell

/** 手机号 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNum_Label;

/**
 车牌号
 */
@property (weak, nonatomic) IBOutlet UILabel *carNum_Label;

/**
 门口
 */
@property (weak, nonatomic) IBOutlet UILabel *gate_Label;

/**
 申请时间
 */
@property (weak, nonatomic) IBOutlet UILabel *applyTime_Label;

/**
 状态
 */
@property (weak, nonatomic) IBOutlet UILabel *state_Label;

/**
 状态图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *state_ImageView;

@property (nonatomic, strong) L_CarNumApplyListModel *listModel;

@property (weak, nonatomic) IBOutlet UILabel *bottom_Label;

@end

//
//  L_GarageDetailTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingCarModel.h"

typedef void(^ButtonsCallBack)(NSInteger buttonIndex);

@interface L_GarageDetailTVC : UITableViewCell

/**
 车辆model
 */
@property (nonatomic, strong) ParkingCarModel *carModel;

/**
 按钮回调
 */
@property (nonatomic, copy) ButtonsCallBack buttonsCallBack;

/**
 初始化图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Init;

/**
 车牌号
 */
@property (weak, nonatomic) IBOutlet UILabel *carNum_Label;

/**
 是否入库
 */
@property (weak, nonatomic) IBOutlet UILabel *isInLabel;

/**
 定时锁车按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *timeLock_Button;

/**
 修改按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *motify_Button;

/**
 删除按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *delete_Button;

/**
 删除按钮宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteButtonLayoutConstraint;

/**
 定时锁车宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLockLayoutConstraint;

/**
 修改按钮宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *motifyLayoutConstraint;

@end

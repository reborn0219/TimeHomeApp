//
//  ParkingDetailVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  车位得租售详情
 */
#import "BaseViewController.h"
#import "UserPublishCar.h"

typedef void(^RefreshDataBlock)();
@interface ParkingDetailVC : THBaseViewController
/**
 *  0 车位租售 1 车位求租购
 */
@property(nonatomic,assign)int jmpCode;
/**
 *  传递的发布车位的model
 */
@property (nonatomic, strong) UserPublishCar *userPublishCar;

@property (nonatomic, copy) RefreshDataBlock refreshDataBlock;

@end

//
//  ReleaseRentalParking.h
//  TimeHomeApp
//
//  Created by us on 16/3/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  发布租售
 */
#import "BaseViewController.h"
#import "UserPublishCar.h"

@interface ReleaseRentalParking : THBaseViewController
/**
 *  修改or保存 typeID = 0保存 1修改
 */
@property (nonatomic, assign) NSInteger typeID;
/// 0. 发布出租 1.发布出售 2.发布求租 3.发布求购

@property(nonatomic,assign) int jmpCode;
/**
 *  草稿传递的发布车位的model
 */
@property (nonatomic, strong) UserPublishCar *userPublishCar;


@end

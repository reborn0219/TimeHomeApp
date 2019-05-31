//
//  SolicitingHouseVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  发布房屋求租，求购
 */
#import "BaseViewController.h"
#import "UserPublishRoom.h"

@interface SolicitingHouseVC : THBaseViewController
/// 0. 求租 1.求购
@property(nonatomic,assign) int jmpCode;

/// 1. 修改 0.发布
@property(nonatomic,assign) int changeCdoe;
/**
 *  草稿房屋信息model
 */
@property(nonatomic,assign) UserPublishRoom *room;
@end

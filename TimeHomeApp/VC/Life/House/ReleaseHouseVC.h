//
//  ReleaseHouseVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  发布租售房源
 */
#import "BaseViewController.h"
#import "UserPublishRoom.h"

@interface ReleaseHouseVC : THBaseViewController
/// 0. 出租 1.出售
@property(nonatomic,assign) int jmpCode;
/// 1. 修改 0.发布
@property(nonatomic,assign) int changeCdoe;
/**
 *  草稿房屋信息model
 */
@property(nonatomic,assign) UserPublishRoom *room;

@end

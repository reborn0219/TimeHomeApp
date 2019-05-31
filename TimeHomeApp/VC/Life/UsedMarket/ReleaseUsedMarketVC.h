//
//  ReleaseUsedMarketVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  发布二手信息
 */

#import "BaseViewController.h"
#import "UserPublishRoom.h"
@interface ReleaseUsedMarketVC : THBaseViewController

/// 1.修改 0.发布
@property(nonatomic,assign) int changeCdoe;
/**
 *  草稿二手物品信息model
 */
@property(nonatomic,assign) UserPublishRoom *room;

@end

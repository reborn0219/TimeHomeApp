//
//  HouseDetailVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  求租售详情
 */
#import "BaseViewController.h"
#import "UserPublishRoom.h"

typedef void(^RefreshDataBlock)();
@interface HouseDetailVC : THBaseViewController

///0.出租 1.出售 2.二手物品
@property(nonatomic,assign) int jumCode;
/**
 *  房屋信息和二手物品共用一个model
 */
@property(nonatomic,assign) UserPublishRoom *room;

@property (nonatomic, copy) RefreshDataBlock refreshDataBlock;

@end

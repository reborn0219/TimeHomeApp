//
//  PACarportService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PABaseRequestService.h"
#import "PACarSpaceModel.h"
@interface PACarSpaceService : PABaseRequestService


/**
 collectionTitleArray;
 */
@property (nonatomic, strong) NSArray * titleArray;


/**
 是否限制车牌修改
 */
@property (nonatomic, assign)NSNumber * limitapp;

/**
 自用车位数组
 */
@property (nonatomic, strong)NSMutableArray <PACarSpaceModel *> * personalCarportArray;

/**
 出租车位数组
 */
@property (nonatomic, strong)NSMutableArray <PACarSpaceModel *>* rentCarportArray;


/**
 加载数据
 */
-(void)loadData;

@end

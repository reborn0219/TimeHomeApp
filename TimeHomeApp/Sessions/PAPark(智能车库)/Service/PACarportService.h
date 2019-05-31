//
//  PACarportService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PABaseRequestService.h"
@interface PACarSpaceService : PABaseRequestService

/**
 自用车位数组
 */
@property (nonatomic, strong)NSMutableArray * personalCarportArray;

/**
 出租车位数组
 */
@property (nonatomic, strong)NSMutableArray * rentCarportArray;

-(void)loadData;

@end

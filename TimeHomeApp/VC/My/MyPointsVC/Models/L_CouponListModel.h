//
//  L_CouponListModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 商城兑换券列表及详情
 */
@interface L_CouponListModel : NSObject

/**
 兑换券名称
 */
@property (nonatomic, strong) NSString *couponname;
/**
 兑换券开始时间
 */
@property (nonatomic, strong) NSString *starttime;
/**
 兑换券结束时间
 */
@property (nonatomic, strong) NSString *endtime;
/**
 //可使用0      商城已使用 1      未生效 2     已失效 3
 */
@property (nonatomic, strong) NSString *couponstate;
/**
 兑换券id
 */
@property (nonatomic, strong) NSString *couponid;
/**
 时间
 */
@property (nonatomic, strong) NSString *systime;
/**
 记录id
 */
@property (nonatomic, strong) NSString *theID;
/**
 规则
 */
@property (nonatomic, strong) NSString *couponrule;

@end

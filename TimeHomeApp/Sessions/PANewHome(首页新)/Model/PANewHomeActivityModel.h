//
//  PANewHomeActivityModel.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/2.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PANewHomeActivityModel : NSObject

@property (nonatomic, strong) NSString *gototype;
/**
 *  1 过期 0 没有
 */
@property (nonatomic, strong) NSString *endtype;
/**
 *  社区id
 */
@property (nonatomic, strong) NSString *communityid;
/**
 *  社区名称
 */
@property (nonatomic, strong) NSString *communityname;
/**
 *  活动标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *  活动描述
 */
@property (nonatomic, strong) NSString *remarks;
/**
 *  活动开始时间
 */
@property (nonatomic, strong) NSString *begindate;
/**
 *  活动结束时间
 */
@property (nonatomic, strong) NSString *enddate;
/**
 *  首图地址
 */
@property (nonatomic, strong) NSString *picurl;
/**
 *  跳转详情的地址
 */
@property (nonatomic, strong) NSString *gotourl;
/**
 *  参与时间
 */
@property (nonatomic, strong) NSString *systime;

/**
 内容
 */
@property (nonatomic, strong) NSString *content;

@end

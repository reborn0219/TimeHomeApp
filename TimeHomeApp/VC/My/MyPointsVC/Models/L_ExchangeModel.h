//
//  L_ExchangeModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 兑换券model
 */
@interface L_ExchangeModel : NSObject

/**
 后台兑换日志id
 */
@property (nonatomic, strong) NSString *theID;
/**
 兑换id 对应php商城兑换id
 */
@property (nonatomic, strong) NSString *convertid;
/**
 兑换时间
 */
@property (nonatomic, strong) NSString *convertibletime;
/**
 核销时间
 */
@property (nonatomic, strong) NSString *cancelledtime;
/**
 商品id
 */
@property (nonatomic, strong) NSString *goodsid;
/**
 订单编号
 */
@property (nonatomic, strong) NSString *ordernum;
/**
 兑换商品数量
 */
@property (nonatomic, strong) NSString *number;
/**
 当前商品状态  -1已过期 0未使用 
 */
@property (nonatomic, strong) NSString *cancellstate;
/**
 商品开始时间
 */
@property (nonatomic, strong) NSString *starttime;
/**
 商品结束时间
 */
@property (nonatomic, strong) NSString *endtime;
/**
 是否还有已使用或者过期的兑换信息 0否1是
 */
@property (nonatomic, strong) NSString *ishaveovertime;
/**
 0为没有使用   1为已经使用
 */
@property (nonatomic, strong) NSString *isused;

/**
 图片
 */
@property (nonatomic, strong) NSString *picurl;

/**
 商品名称
 */
@property (nonatomic, strong) NSString *goodsname;
/**
 商家名称
 */
@property (nonatomic, strong) NSString *merchantname;
/**
 是否即将过期，0否1是
 */
@property (nonatomic, strong) NSString *istodate;

/**
 是否可以赠予 0否1是
 */
@property (nonatomic, strong) NSString *ispresent;


/** 订单处为非赠与，不对这两个字段进行维护 */
/**
 是否赠送
 */
@property (nonatomic, strong) NSString *isexch;
/**
 赠予时间
 */
@property (nonatomic, strong) NSString *systime;
/**
 被谁赠送
 */
@property (nonatomic, strong) NSString *preusername;

//-------------自定义----------------

/**
 cell高度
 */
@property (nonatomic, assign) CGFloat height;

@end

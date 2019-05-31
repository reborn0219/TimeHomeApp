//
//  PARedBagDetailModel.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/*红包模型*/

@interface PARedBagDetailModel : NSObject

@property (copy,nonatomic) NSString *orderid;//卡券ID
@property (copy,nonatomic) NSString *userticketid;//卡券ID
@property (assign,nonatomic) CGFloat amount;//红包金额
@property (assign,nonatomic) NSUInteger type;//卡券类型:0红包1卡券
@property (copy,nonatomic) NSString *redlink;//广告地址
@property (copy,nonatomic) NSString *logourl;//商家logo地址
@property (copy,nonatomic) NSString *backgroundpic;//商家广告背景
@property (copy,nonatomic) NSString *unpackpic;//红包背景图
@property (copy,nonatomic) NSString *redname;//发的红包
@property (copy,nonatomic) NSString *redmessage;//红包祝语
@property (copy,nonatomic) NSString *systime;//建立时间
@property (copy,nonatomic) NSString *picurl;//红包显示图片地址
@property (assign,nonatomic) NSUInteger state;//状态：红包：0未使用1已使用  卡券：0未使用1已使用2已失效
@property (copy,nonatomic) NSString *couponsname;//卡券名称
@property (assign,nonatomic) CGFloat cheapamount;//优惠金额
@property (assign,nonatomic) NSUInteger discount;//折扣比例
@property (copy,nonatomic) NSString *validate;//有效日期
@property (copy,nonatomic) NSString *code;//券码
@property (copy,nonatomic) NSString *disexplanation;//优惠说明
@property (copy,nonatomic) NSString *explanation;//使用说明
@property (assign,nonatomic) NSUInteger tickettype;//优惠券类型 1代金券  2折扣券  3体验券 4礼品券

@end

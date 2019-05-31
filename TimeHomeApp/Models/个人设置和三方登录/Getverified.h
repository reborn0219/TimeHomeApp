//
//  Getverified.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/31.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 获得实名认证
 */
#import <Foundation/Foundation.h>

@interface Getverified : NSObject
/**
 picurl	申请的照片
 state	状态 0 申请中 1 审核通过 -1 审核未通过
 applytime	申请时间
 auditremarks	审核备注
 */
@property(nonatomic,copy)NSString *picurl;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *applytime;
@property(nonatomic,copy)NSString *auditremarks;
@end

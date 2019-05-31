//
//  GetMyBinding.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/11/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetMyBinding : NSObject
@property(nonatomic,copy)NSString *type;        //第三方类型 1 qq 2 微信 3 微博
@property(nonatomic,copy)NSString *isbinding;   //是否绑定  1 是0否
@property(nonatomic,copy)NSString *account;   //用户名
@property(nonatomic,copy)NSString *thirdid;   //用户id
@property(nonatomic,copy)NSString *thirdtoken;   //第三方用户token
@property (nonatomic, copy) NSString *unionid; //用户unionid
@end

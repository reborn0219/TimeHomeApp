//
//  UserIntergralLog.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/31.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  用户积分日志
 */
#import <Foundation/Foundation.h>

@interface UserIntergralLog : NSObject
/**
 *  登录后获得的积分
 */
@property (nonatomic, strong) NSString *integral;
/**
 *  记录所对应的规则类型 1 登录 2 完善资料 3 首次发帖 4 首次话题 5 新闻评论
 */
@property (nonatomic, strong) NSString *type;
/**
 *  内容描述
 */
@property (nonatomic, strong) NSString *remarks;
/**
 *  记录创建时间
 */
@property (nonatomic, strong) NSString *systime;

//---------------自定义------------------------

@property (nonatomic, assign) CGFloat height;

@end

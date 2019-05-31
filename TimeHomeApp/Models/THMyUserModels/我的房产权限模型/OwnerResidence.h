//
//  OwnerResidence.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的房产权限列表model
 */
#import <Foundation/Foundation.h>

@interface OwnerResidence : NSObject
/**
 *  住宅id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  社区名称
 */
@property (nonatomic, strong) NSString *communityname;
/**
 *  住宅名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  建筑面积
 */
@property (nonatomic, strong) NSString *builtuparea;
/**
 *  使用面积
 */
@property (nonatomic, strong) NSString *usearea;
/**
 *  服务到期时间
 */
@property (nonatomic, strong) NSString *expiretime;
/**
 *  权限类型：0 自用，1共享，2出租
 */
@property (nonatomic, strong) NSString *type;
/**
 *  拥有权限的用户列表
 */
@property (nonatomic, strong) NSArray *userlist;

@property (nonatomic, copy) NSString *todateshow;
@property (nonatomic, copy) NSString *istodateshow;/** 为1时显示上面的字段 */

//-----自定义------------

/**
 cell高度
 */
@property (nonatomic, assign) CGFloat height;

@end

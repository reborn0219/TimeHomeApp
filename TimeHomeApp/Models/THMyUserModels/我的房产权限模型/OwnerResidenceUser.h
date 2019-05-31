//
//  OwnerResidenceUser.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的房产权限列表和车位权限列表中拥有权限的用户
 */
#import <Foundation/Foundation.h>

@interface OwnerResidenceUser : NSObject
/**
 *  权限记录表id
 */
@property (nonatomic, strong) NSString *powerid;
/**
 *  权限分配备注用户名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  权限分配用户手机号
 */
@property (nonatomic, strong) NSString *phone;
/**
 *  租用开始日期
 */
@property (nonatomic, strong) NSString *rentbegindate;
/**
 *  租用结束日期
 */
@property (nonatomic, strong) NSString *rentenddate;

@end

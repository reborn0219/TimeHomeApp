//
//  UserVisitor.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的访客列表model
 */
#import <Foundation/Foundation.h>

@interface UserVisitor : NSObject
/**
 *  记录id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  社区名称
 */
@property (nonatomic, strong) NSString *communityname;
/**
 *  通行类型 0 住宅 1 住宅和车位 2 单车位
 */
@property (nonatomic, strong) NSString *type;
/**
 *  住宅名称
 */
@property (nonatomic, strong) NSString *residencename;
/**
 *  访客日期
 */
@property (nonatomic, strong) NSString *visitdate;
/**
 *  访客车牌
 */
@property (nonatomic, strong) NSString *visitcard;
/**
 *  权限 0 进小区 1 单元门  2 电梯
 */
@property (nonatomic, strong) NSString *power;
/**
 *  访客名称
 */
@property (nonatomic, strong) NSString *visitname;
/**
 *  访客手机号
 */
@property (nonatomic, strong) NSString *visitphone;
/**
 分享网页地址
 */
@property(nonatomic,copy) NSString * gotourl;

///经度
@property(nonatomic,copy) NSString * positionx;
///纬度
@property(nonatomic,copy) NSString * positiony;

///业主留言
@property (nonatomic, copy) NSString *leavemsg;
///邀请人手机号
@property (nonatomic, copy) NSString *ownerphone;
///邀请人姓名
@property (nonatomic, copy) NSString *ownername;
///是否无效----1访客信息无效  0有效
@property (nonatomic, copy) NSString *isinvalid;
///朋友的地址
@property (nonatomic, copy) NSString *friendaddress;
///门禁权限
@property (nonatomic, copy) NSString *permissions;

@end

//
//  L_HouseInfoModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "L_PowerListModel.h"

/**
 房产详情model
 */
@interface L_HouseInfoModel : NSObject

/**
 社区id
 */
@property (nonatomic, strong) NSString *communityid;
/**
 社区名称
 */
@property (nonatomic, strong) NSString *communityname;
/**
 认证时间 未认证为空
 */
@property (nonatomic, strong) NSString *certtime;
/**
 社区地址
 */
@property (nonatomic, strong) NSString *address;
/**
 房产id 或者申请id
 */
@property (nonatomic, strong) NSString *theID;
/**
 房间名称
 */
@property (nonatomic, strong) NSString *resiname;
/**
 业主名称
 */
@property (nonatomic, strong) NSString *householder;
/**
 业主手机号
 */
@property (nonatomic, strong) NSString *phone;
/**
 授权类型 0 业主 1 共享 2 出租
 */
@property (nonatomic, strong) NSString *type;
/**
 是否业主 1 当前房产业主 0 被授权人
 */
@property (nonatomic, strong) NSString *isowner;
/**
 被授权的时间；如果为 被授权人的话有该时间；没有powerlist
 */
@property (nonatomic, strong) NSString *powertime;
/**
 授权集合
 */
@property (nonatomic, strong) NSArray *powerlist;

/**
 租期开始时间
 */
@property (nonatomic, strong) NSString *rentbegindate;

/**
 租期结束时间
 */
@property (nonatomic, strong) NSString *rentenddate;

//----------cell高度-----------------------------
@property (nonatomic, assign) CGFloat height;

/**
 业主： 0 已通过认证 1 审核中 2 未通过审核 3 已通过认证 共享 4 已通过认证 出租 || 被授权：1.出租 2.共享
 */
@property (nonatomic, assign) NSInteger infoType;
/**
 认证失败的原因
 */
@property (nonatomic, copy) NSString *remark;

@end

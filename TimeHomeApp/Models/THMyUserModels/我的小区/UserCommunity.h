//
//  UserCommunity.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的小区列表model
 */
#import <Foundation/Foundation.h>

@interface UserCommunity : NSObject
/**
 *  社区id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  社区名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  是否已认证
 */
@property (nonatomic, strong) NSString *iscert;
/**
 *  社区地址
 */
@property (nonatomic, strong) NSString *address;
/**
 *  是否填写认证信息
 */
@property (nonatomic, strong) NSString *haverecord;
/**
 *  认证填写的名称
 */
@property (nonatomic, strong) NSString *certname;
/**
 *  认证的楼栋
 */
@property (nonatomic, strong) NSString * certbuiding;
/**
 *  认证房间号
 */
@property (nonatomic, strong) NSString *certnumber;
/**
 *  0 认证中 1 认证成功 2 认证失败
 */
@property (nonatomic, strong) NSString * certstate;

//-----自定义------
/**
 cell高度
 */
@property (nonatomic, assign) CGFloat height;


@end

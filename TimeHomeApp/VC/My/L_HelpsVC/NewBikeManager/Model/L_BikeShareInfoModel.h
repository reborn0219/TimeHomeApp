//
//  L_BikeShareInfoModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface L_BikeShareInfoModel : NSObject

/**
 共享的用户id
 */
@property (nonatomic, strong) NSString *shareuserid;
/**
 共享的用户姓名 / 被共享的用户名称
 */
@property (nonatomic, strong) NSString *sharename;
/**
 共享的用户手机号 / 被共享的手机号
 */
@property (nonatomic, strong) NSString *mobilephone;
/**
 被共享的用户id
 */
@property (nonatomic, strong) NSString *userid;
/**
 被共享id
 */
@property (nonatomic, strong) NSString *theID;
/**
 发送权限时间
 */
@property (nonatomic, strong) NSString *sharetime;

@end

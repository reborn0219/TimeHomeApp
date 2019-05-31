//
//  L_MyFollowersModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/11/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 我关注的用户model
 */
@interface L_MyFollowersModel : NSObject

/**
 发帖用户id
 */
@property (nonatomic, strong)  NSString *userid;
/**
 用户昵称
 */
@property (nonatomic, strong)  NSString *nickname;
/**
 用户头像
 */
@property (nonatomic, strong)  NSString *userpicurl;
/**
 性别 1 男  女
 */
@property (nonatomic, strong)  NSString *sex;
/**
 年龄
 */
@property (nonatomic, strong)  NSString *age;

@end

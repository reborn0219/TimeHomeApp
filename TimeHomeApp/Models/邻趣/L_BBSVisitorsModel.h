//
//  L_BBSVisitorsModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 访客列表model
 */
@interface L_BBSVisitorsModel : NSObject

/**
 用户ID
 */
@property (nonatomic, strong) NSString *userid;
/**
 用户昵称
 */
@property (nonatomic, strong) NSString *nickname;
/**
 头像地址
 */
@property (nonatomic, strong) NSString *picurl;
/**
 访问时间
 */
@property (nonatomic, strong) NSString *accesstime;

/**
 访问记录id
 */
@property (nonatomic, strong) NSString *accessid;

@end

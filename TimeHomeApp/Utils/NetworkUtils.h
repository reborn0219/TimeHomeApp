//
//  NetworkUtils.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/11/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 网络相关工具类
 */
#import <Foundation/Foundation.h>

@interface NetworkUtils : NSObject

/**
 判断url链接是否有效
 */
+ (void)validateUrl:(NSString *)str callBack:(void(^)(BOOL isOK))callback;

@end

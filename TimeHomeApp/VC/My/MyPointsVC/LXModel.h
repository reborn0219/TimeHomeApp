//
//  LXModel.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  模拟数据,部分数据用来存放固定内容的
 */
@interface LXModel : NSObject
/**
 *  用来存放固定内容
 */
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) float height;

@property (nonatomic, assign) BOOL hideShowButton;

/**
 0 已通过认证 1 审核中
 */
@property (nonatomic, assign) NSInteger type;

@end

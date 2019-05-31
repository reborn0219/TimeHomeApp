//
//  L_ResiListModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 当前社区待认证的房产列表model
 */
@interface L_ResiListModel : NSObject

/**
 业主姓名
 */
@property (nonatomic, copy) NSString *householder;
/**
 业主电话
 */
@property (nonatomic, copy) NSString *phone;
/**
 社区名称
 */
@property (nonatomic, copy) NSString *communityname;
/**
 房间名称拼接楼 + 单元 + 房间号
 */
@property (nonatomic, copy) NSString *resiname;

//-------cell高度--------------------
@property (nonatomic, assign) CGFloat height;

@end

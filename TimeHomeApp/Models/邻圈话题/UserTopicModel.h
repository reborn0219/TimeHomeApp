//
//  UserTopicModel.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  我的话题列表model
 */
@interface UserTopicModel : NSObject
/**
 *  话题id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  话题标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *  话题描述
 */
@property (nonatomic, strong) NSString *remarks;
/**
 *  话题标图
 */
@property (nonatomic, strong) NSString *picurl;
/**
 *  审核状态 0 审核中 1 审核通过 2 未审核通过
 */
@property (nonatomic, strong) NSString *state;
/**
 *  参与人数
 */
@property (nonatomic, strong) NSString *usercount;

@property (nonatomic, strong) NSString *topicgotourl;
///审核未通过原因
@property (nonatomic,strong)NSString * auditremarks;

@end

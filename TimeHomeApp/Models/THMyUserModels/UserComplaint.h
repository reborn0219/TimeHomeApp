//
//  UserComplaint.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的投诉model
 */
#import <Foundation/Foundation.h>

@interface UserComplaint : NSObject
/**
 *  预约id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  投诉单号
 */
@property (nonatomic, strong) NSString *complaintno;
/**
 *  投诉物业id
 */
@property (nonatomic, strong) NSString *propertyid;
/**
 *  物业名称
 */
@property (nonatomic, strong) NSString *propertyname;
/**
 *  投诉内容
 */
@property (nonatomic, strong) NSString *content;
/**
 *  0 未回复 1 已回复
 */
@property (nonatomic, strong) NSString *state;
/**
 *  回复内容
 */
@property (nonatomic, strong) NSString *views;
/**
 *  回复时间
 */
@property (nonatomic, strong) NSString *viewsdate;
/**
 *  创建时间
 */
@property (nonatomic, strong) NSString *systime;

@property (nonatomic, strong) NSMutableArray *piclist;

@end

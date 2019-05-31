//
//  LXModel2.h
//  TimeHomeApp
//
//  Created by 李世博 on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  模拟数据model2,后期可删除
 */
#import <Foundation/Foundation.h>

@interface LXModel2 : NSObject
//---------我的投诉--------------
/**
 *  处理状态，待处理0，已处理1
 */
@property (nonatomic, assign) NSInteger accessState;
/**
 *  提交时间
 */
@property (nonatomic, strong) NSString *timeString;
/**
 *  投诉内容
 */
@property (nonatomic, strong) NSString *contentString;

/**
 *  投诉列表or详情界面
 */
@property (nonatomic, assign) BOOL isDetailVC;
/**
 *  投诉单号
 */
@property (nonatomic, strong) NSString *complainID;
/**
 *  投诉时间
 */
@property (nonatomic, strong) NSString *complainTime;
/**
 *  描述内容
 */
@property (nonatomic, strong) NSString *complainContents;
/**
 *  描述内容图片数组
 */
@property (nonatomic, strong) NSArray *picArray;
/**
 *  物业名称
 */
@property (nonatomic, strong) NSString *propertyName;
/**
 *  物业回复内容
 */
@property (nonatomic, strong) NSString *propertyReplys;
/**
 *  物业回复时间
 */
@property (nonatomic, strong) NSString *propertyReplysTime;
//--------------------------------
/**
 *  房源图片
 */
@property (nonatomic, strong) NSString *imageUrl;
/**
 *  房源标题
 */
@property (nonatomic, strong) NSString *houseName;
/**
 *  房源副标题
 */
@property (nonatomic, strong) NSString *houseDetailName;
/**
 *  房源价格
 */
@property (nonatomic, strong) NSString *housePrice;
/**
 *  房源状态 0-出租，1-出售，2-草稿，3-求租，4-求购
 */
@property (nonatomic, assign) NSInteger houseState;
@end

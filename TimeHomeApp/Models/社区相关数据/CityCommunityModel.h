//
//  CityCommunityModel.h
//  TimeHomeApp
//
//  Created by us on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///保存城市或社区信息
#import <Foundation/Foundation.h>

@interface CityCommunityModel : NSObject
///城市或社区id
@property(nonatomic,copy) NSString * ID;
///城市或社区名称
@property(nonatomic,copy) NSString * name;
///地址
@property(nonatomic,copy) NSString * address;
///人数
@property(nonatomic,copy) NSNumber * usercount;
///字母排序
@property(nonatomic,copy) NSString * firstletter;
///区域编号
@property(nonatomic,copy) NSString * areacode;
///是否选中
@property(nonatomic,assign) BOOL isSelect;

/** 经度 */
@property(nonatomic,copy) NSString *longitude;
/** 纬度 */
@property(nonatomic,copy) NSString *latitude;


@end

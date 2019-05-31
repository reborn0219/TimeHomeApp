//
//  ZSY_GetMyCarList.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSY_GetMyCarList : NSObject


/**
 id
 ucarid我的车辆id
 card
 车牌号
 alias
 别名
 picurl
 品牌图标url
 isbinding
 是否绑定
 brandname
 品牌名称
 seriesname
 车系名称
 modelsname
 车型名称
 **/
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * card;
@property (nonatomic, strong) NSString * alias;
@property (nonatomic, strong) NSString * picurl;
@property (nonatomic, strong) NSString * isbinding;
@property (nonatomic, strong) NSString * brandname;
@property (nonatomic, strong) NSString * seriesname;
@property (nonatomic, strong) NSString * modelsname;


@end

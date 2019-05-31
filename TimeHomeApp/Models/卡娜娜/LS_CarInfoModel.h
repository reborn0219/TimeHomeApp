//

//  LS_CarInfoModel.h
//  TimeHomeApp
//  Created by 优思科技 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import <Foundation/Foundation.h>

//”id”:”12323ddfd223”
//,”card”:”车牌号”
//,”alias”:”车辆别名”
//,”brandid”:”12”
//,”seriesid”:”2”
//,”modelsid”:”12”
//,”brandname”:”12”
//,”seriesname”:”2”
//,”modelsname”:”12”
//,”engineno”:”发动机号”
//,”chassisno”:”车架号”
//,”displacement”:1.6
//,”gearbox”:”AT”
//,”fueltype”:”0”
//,”isbinding”:1
//,”deviceno”:”155315223152322”


@interface LS_CarInfoModel : NSObject

@property (nonatomic, strong) NSString * carID;
///车牌号
@property (nonatomic, strong) NSString * card;
///车辆别名
@property (nonatomic, strong) NSString * alias;
@property (nonatomic, strong) NSString * brandid;
@property (nonatomic, strong) NSString * seriesid;
@property (nonatomic, strong) NSString * modelsid;
@property (nonatomic, strong) NSString * brandname;
@property (nonatomic, strong) NSString * seriesname;
@property (nonatomic, strong) NSString * modelsname;
///发动机号
@property (nonatomic, strong) NSString * engineno;
///车架号
@property (nonatomic, strong) NSString * chassisno;
///排量
@property (nonatomic, strong) NSString * displacement;
@property (nonatomic, strong) NSString * gearbox;
@property (nonatomic, strong) NSString * fueltype;
@property (nonatomic, strong) NSString * isbinding;
@property (nonatomic, strong) NSString * deviceno;
@property (nonatomic, strong) NSString * picurl;
@property (nonatomic, strong) NSString * condition;//是否有报警


@end

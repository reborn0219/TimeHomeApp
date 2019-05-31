//
//  ZSY_CarHomePageShowModel.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSY_CarHomePageShowModel : NSObject

/**
 id                         车辆信息
 ucarid                     我的车辆id
 card                       车牌号
 alias                      别名
 
 picurl                     品牌图标地址
 brandname                  品牌名称
 seriesname                 车系名称
 
 modelsname                 车型名称
 speed                      时速
 oilconsumption             临时油耗
 speed                      时速
 rpm                        转速
 temperature                温度
 voltage                    电压
 
 online                     状态:0熄火1正常运行
 condition                  状态:0正常1存在报警
 lastontime                 最后熄火时间
 
 warncount                  未读报警个数
 */

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *card;
@property (nonatomic, copy) NSString *alias;

@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, copy) NSString *brandname;
@property (nonatomic, copy) NSString *seriesname;

@property (nonatomic, copy) NSString *modelsname;
@property (nonatomic, copy) NSString *speed;
@property (nonatomic, copy) NSString *oilconsumption;

@property (nonatomic, copy) NSString *rpm;
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, copy) NSString *voltage;

@property (nonatomic, copy) NSString *online;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, copy) NSString *lastontime;

@property (nonatomic, copy) NSString *warncount;
@property (nonatomic, copy) NSString *isbinding;
@end

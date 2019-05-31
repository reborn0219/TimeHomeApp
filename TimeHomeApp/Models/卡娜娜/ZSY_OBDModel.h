//
//  ZSY_OBDModel.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/20.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *OBD详情Model
 **/
#import <Foundation/Foundation.h>

@interface ZSY_OBDModel : NSObject
/**
 ”datakey”:”电瓶电压”  数据项名称
 ”datavalue”:”12.3”   数据项值
 “datacontent”;”稳定”  数据项内容
 ,”lasttime”:”2015-01-01 12:12:12”  最后时间
 */
@property (nonatomic, strong) NSString *datakey;
@property (nonatomic, strong) NSString *datavalue;
@property (nonatomic, strong) NSString *datacontent;
@property (nonatomic, strong) NSString *lasttime;
@property (nonatomic, strong) NSString *company;

@end

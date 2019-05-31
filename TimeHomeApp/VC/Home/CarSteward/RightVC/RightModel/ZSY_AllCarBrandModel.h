//
//  ZSY_AllCarBrandModel.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 * 车辆品牌模型
 **/

#import <Foundation/Foundation.h>

@interface ZSY_AllCarBrandModel : NSObject
/**
id
name                名称
firstletter         首字母
ishot               是否热门
picurl              图片地址
 */
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *firstletter;
@property (nonatomic, copy) NSString *ishot;
@property (nonatomic, copy) NSString *picurl;
@end

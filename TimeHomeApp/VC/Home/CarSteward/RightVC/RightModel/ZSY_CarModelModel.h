//
//  ZSY_CarModelModel.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  车系模型
 **/

#import <Foundation/Foundation.h>

@interface ZSY_CarModelModel : NSObject
/**
 id 车系id
 name 车系名称
 */

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@end

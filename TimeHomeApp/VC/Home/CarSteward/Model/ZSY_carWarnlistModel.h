//
//  ZSY_carWarnlistModel.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSY_carWarnlistModel : NSObject

/**
 id 报警信息ID
 typename 报警类型名称
 content  报警内存
 systime  报警时间
 */
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *typeName;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *systime;

@end

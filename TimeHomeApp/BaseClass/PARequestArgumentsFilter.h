//
//  PARequestArgumentsFilter.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PARequestArgumentsFilter : NSObject<YTKUrlFilterProtocol>

+ (PARequestArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

@end

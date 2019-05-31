//
//  BaseCommand.h
//  TimeHomeApp
//
//  Created by us on 16/1/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 所有命令基类，实现不同数据源的数据获取和存储。
 **/
#import <Foundation/Foundation.h>
#import "CommandModel.h"

@interface BaseCommand : NSObject

///执行方法
-(void) execute:(CommandModel *)param CompleteBlock:(CommandCompleteBlock)completeBlock;

@end

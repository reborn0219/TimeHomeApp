//
//  DataController.h
//  TimeHomeApp
//
//  Created by us on 16/1/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 数据控制器，为工厂类
 生成BaseCommand的子类，实现不同命令调用
 **/
#import <Foundation/Foundation.h>
#import "BaseCommand.h"

@interface DataController : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(DataController);

///工厂方法，生成所需的类对象
- (BaseCommand *)createCommandWithName:(NSString *)className;

///执行命令请求
-(void)executeCommand:(CommandModel *)param className:(NSString *)className CompleteBlock:(CommandCompleteBlock)completeBlock;

/**
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData;

/// 将字典或者数组转化为JSON串
+ (NSData *)toJSONData:(id)theData;
@end

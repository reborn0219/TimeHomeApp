//
//  DataController.m
//  TimeHomeApp
//
//  Created by us on 16/1/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "DataController.h"

@implementation DataController

SYNTHESIZE_SINGLETON_FOR_CLASS(DataController);

- (BaseCommand *)createCommandWithName:(NSString *)className
{
    //通过string得到类的结构体
    Class class = NSClassFromString(className);
    //通过转化的class得到实例对象
    BaseCommand * provider = (BaseCommand *)[[class alloc] init];
    
    //调用对象方法
//    if ([provider respondsToSelector:@selector(show)])
//    {
//        [provider show];
//    }

    return provider;
}
///执行命令
-(void)executeCommand:(CommandModel *)param className:(NSString *)className CompleteBlock:(CommandCompleteBlock)completeBlock
{
    BaseCommand * command=[self createCommandWithName:className];
    //执行子类实现的方法
    [command execute:param CompleteBlock:completeBlock];
}

/**
 * 把格式化的JSON格式的数据转换成字典
 * @param jsonData JSON格式的数据
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData {
    if (jsonData == nil) {
        return nil;
    }
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

// 将字典或者数组转化为JSON串
+ (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

@end

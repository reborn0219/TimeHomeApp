//
//  NullPointerUtils.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/11/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NullPointerUtils.h"

@implementation NullPointerUtils

+(NSDictionary *)toDealWithNullPointer:(NSDictionary *)dic
{
    
    NSArray *arr = [dic allKeys];
    ///如果没有数据需要返回否则崩溃
    if (arr == nil||[arr isKindOfClass:[NSNull class]]) {
        return [NSDictionary new];
    }
    
    NSMutableDictionary * temp = [NSMutableDictionary dictionaryWithDictionary:dic];
    for (NSString * s in arr) {
        if ([dic[s] isKindOfClass:[NSString class]]) {
            
            if([XYString isBlankString:dic[s]])
            {
                [temp setObject:@"" forKey:s];
            }
        }else if ([dic[s] isKindOfClass:[NSArray class]]){
        
            if (dic[s] == nil || ((NSArray *)dic[s]).count == 0) {
                NSArray *arr0 = @[];
                [temp setObject:arr0 forKey:s];
            }
        }
    }
    return temp;
}

+(NSArray *)toDealWithNullArr:(NSArray *)arr{
    
    ///如果没有数据需要返回否则崩溃
    if (arr == nil||[arr isKindOfClass:[NSNull class]]) {
        return [NSArray new];
    }
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        
        NSDictionary *dic = arr[i];
        
        NSArray *arr = [dic allKeys];
        NSMutableDictionary * temp = [NSMutableDictionary dictionaryWithDictionary:dic];
        for (NSString * s in arr) {
            
            if ([dic[s] isKindOfClass:[NSString class]]) {
                
                if([XYString isBlankString:dic[s]])
                {
                    [temp setObject:@"" forKey:s];
                }
            }else if ([dic[s] isKindOfClass:[NSArray class]]){
                
                if (dic[s] == nil) {
                    NSArray *arr0 = @[];
                    [temp setObject:arr0 forKey:s];
                }
            }
        }
        [dataArr addObject:temp];
    }
    return dataArr;
}

@end

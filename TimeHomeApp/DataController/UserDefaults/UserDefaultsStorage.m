//
//  UserDefaultsStorage.m
//  YouLifeApp
//
//  Created by us on 15/8/17.
//  Copyright © 2015年 us. All rights reserved.
//

#import "UserDefaultsStorage.h"
#import "MacroDefinition.h"
#import "UserData.h"

@implementation UserDefaultsStorage

+(void) saveData:(nullable id)value forKey:(NSString *)defaultName
{
    if ([XYString isBlankString:defaultName]) {
        NSLog(@"存储Key为空值！");
        return;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    [USER_DEFAULT setObject:data forKey:defaultName];
    [USER_DEFAULT synchronize];
}
///保存自定义对象数组
+(void)saveCustomArray:(_Nullable id)object forKey:(nullable NSString *)key
{
    
    if ([XYString isBlankString:key]) {
        NSLog(@"存储Key为空值！");
        return;
    }
    NSData * dataobject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [USER_DEFAULT setObject:dataobject forKey:key];
    [USER_DEFAULT synchronize];
    
}
///获取数据
+(nullable id)getDataforKey:(nullable  NSString *)key
{
    if ([XYString isBlankString:key]) {
        NSLog(@"存储Key为空值！");
        return nil;
    }
    NSData * dataobject = [USER_DEFAULT objectForKey:key];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:dataobject];
    return object;
}

@end


//
//  UserDefaultsStorage.h
//  YouLifeApp
//
//  Created by us on 15/8/17.
//  Copyright © 2015年 us. All rights reserved.
//

/**
 NSUserDefaults数据简单存储,用于存储简单数据对象
 **/

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserDefaultsStorage : NSObject

///保存数据
+(void) saveData:(nullable id)value forKey:(nullable  NSString *)defaultName;
///保存自定义对象数组
+(void)saveCustomArray:(_Nullable id)object forKey:(nullable NSString *)key;
///获取数据
+(nullable id)getDataforKey:(nullable  NSString *)defaultName;


@end

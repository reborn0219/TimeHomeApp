//
//  PAIPAddressManager.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/12.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAIPAddressManager : NSObject
+ (instancetype)Instance;
- (NSString *)getIPAddress:(BOOL)preferIPv4;

@end

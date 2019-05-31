//
//  PAVersionManager.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAVersionManager : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(PAVersionManager)

/**
 主动调用检查新版本
 */
- (void)versionCheck;
@end

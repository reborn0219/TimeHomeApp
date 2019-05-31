//
//  PAVersionService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"
#import "PAVersionModel.h"
@interface PAVersionService : PABaseRequestService

@property (nonatomic, strong)PAVersionModel * versionModel;
/**
 获取服务器新版本提示信息
 */
- (void)versionInfoCheck;
@end

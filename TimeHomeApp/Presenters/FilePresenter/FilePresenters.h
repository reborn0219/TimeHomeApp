//
//  FilePresenters.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

#define FilePresentersManager [FilePresenters sharedPresenter]

/**
 文件管理
 */
@interface FilePresenters : BasePresenters

@property (nonatomic, copy) void(^callBack)(NSInteger success);

/**
 单例
 */
+ (instancetype)sharedPresenter;

/**
 显示缓存大小
 */
- (float)filePath;

/**
 清理缓存
 */
- (void)clearFileWithBlock:(void(^)(NSInteger success))callBack;

@end

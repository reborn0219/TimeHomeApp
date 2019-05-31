//
//  YYCarInfoModel.h
//  TimeHomeApp
//
//  Created by 世博 on 16/8/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCarInfoModel : NSObject


@property (nonatomic, strong) NSString *number;

/**
 *  故障码
 */
@property (nonatomic, strong) NSString *code;

/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  英文标题
 */
@property (nonatomic, strong) NSString *titleEnglish;

/**
 *  类型
 */
@property (nonatomic, strong) NSString *type;

/**
 *  内容
 */
@property (nonatomic, strong) NSString *content;

/**
 *  cell高度
 */
@property (nonatomic, assign) float rowHeight;

/**
 *  判断为故障
 */
@property (nonatomic, assign) BOOL isFault;

@end

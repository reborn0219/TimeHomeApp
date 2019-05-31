//
//  L_RecordListModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 中奖纪录model
 */
@interface L_RecordListModel : NSObject

/**
 中奖描述
 */
@property (nonatomic, strong) NSString *rewarddesc;
/**
 时间
 */
@property (nonatomic, strong) NSString *systime;

@end

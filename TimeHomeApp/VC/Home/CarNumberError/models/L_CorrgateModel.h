//
//  L_CorrgateModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 获得车牌纠错需要的门口列表model
 */
@interface L_CorrgateModel : NSObject

/**
 门口甬道id
 */
@property (nonatomic, strong) NSString *theID;
/**
 显示名称 拼接了 车库 + 门口 + 进出
 */
@property (nonatomic, strong) NSString *aislename;
/**
 当前车牌是否可以驶入
 */
@property (nonatomic, strong) NSString *iscarin;

//--------自定义------
@property (nonatomic, assign) CGFloat height;

@end

//
//  ZSY_MyGPSModel.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSY_MyGPSModel : NSObject

/**
 direction 角度
 mapx      坐标X
 mapy      坐标y
 */
@property (nonatomic,copy)NSString *direction;
@property (nonatomic,copy)NSString *mapx;
@property (nonatomic,copy)NSString *mapy;
@end

//
//  L_ContactPropertyModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/25.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 联系物业
 */
@interface L_ContactPropertyModel : NSObject

/**
 物业名称
 */
@property (nonatomic, strong) NSString *propertyname;
/**
 姓名
 */
@property (nonatomic, strong) NSString *name;
/**
 电话
 */
@property (nonatomic, strong) NSString *telephone;

/**
 cell高度
 */
@property (nonatomic, assign) CGFloat height;


@end

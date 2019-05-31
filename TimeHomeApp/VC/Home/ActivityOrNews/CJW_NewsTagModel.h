//
//  CJW_NewsTagModel.h
//  TimeHomeApp
//
//  Created by cjw on 2018/1/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJW_NewsTagModel : NSObject

// 标签名
@property (nonatomic,copy) NSString *title;

//颜色
@property (nonatomic,strong) UIColor *color;
@end

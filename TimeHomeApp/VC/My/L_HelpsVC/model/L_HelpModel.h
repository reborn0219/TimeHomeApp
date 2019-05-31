//
//  L_HelpModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/11/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 帮助与反馈model
 */
@interface L_HelpModel : NSObject

/**
 类型id
 */
@property (nonatomic, strong)  NSString *theID;
/**
 标题
 */
@property (nonatomic, strong)  NSString *title;
/**
 上级id，帮助分类应该为两级
 */
@property (nonatomic, strong)  NSString *fatherid;
/**
 内容 如果内容和地址为空，则不显示终极页
 */
@property (nonatomic, strong)  NSString *content;
/**
 html地址
 */
@property (nonatomic, strong)  NSString *gotourl;

@end

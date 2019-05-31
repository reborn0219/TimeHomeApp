//
//  PMDataModel.h
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  物业服务功能分类数据和生活分类数据
 */

#import <Foundation/Foundation.h>

@interface PMDataModel : NSObject
/**
 *  功能标题
 */
@property(nonatomic,strong)NSString * strTitle;
/**
 *  功能英文图片名称
 */
@property(nonatomic,strong)NSString * strEngLishImgName;
/**
 *  功能图标
 */
@property(nonatomic,strong)NSString * strIcon;



@end

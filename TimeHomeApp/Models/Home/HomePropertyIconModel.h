//
//  HomePropertyIconModel.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePropertyIconModel : NSObject

/**
 *功能标识
 */
@property (nonatomic, strong) NSString *key;
/**
 *  图标key
 */
@property (nonatomic, strong) NSString *pickey;

/**
 *  功能标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *  功能类型：0 原生 1 html5
 */
@property (nonatomic, strong) NSString *type;
/**
 *  跳转地址
 */
@property (nonatomic, strong) NSString *gotourl;

@property (nonatomic, strong) NSString *isredenvelope;

///图片地址
@property (nonatomic, copy) NSString *picurl;

/**
 *  用户后台控制权限的资源ID
 */
@property (nonatomic, strong) NSString *keynum;

/**
 errcode”:0
 ,”errmsg”:””
 ,”list”:[{
 ,”key”:”car”
 ,”pickey”:”car”
 ,”title”:”智能门禁”
 ,”type”:0
 ,”gotourl”
 */
///是否是业主
@property (nonatomic, copy) NSString *ownerpowertype;

@end

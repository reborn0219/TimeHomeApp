//
//  MyJFButton.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的首页余额与积分两个按钮
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import <UIKit/UIKit.h>

@interface MyJFButton : UIButton
/**
 *  左边图片类型，余额--0 or 积分--1
 */
@property (nonatomic, assign) NSInteger imageType;
/**
 *  积分或余额数量
 */
@property (nonatomic, strong) NSString *jfCountString;//
/**
 *  积分或余额名称
 */
@property (nonatomic, strong) NSString *jfNameString;//
//@property (nonatomic, strong) NSString *leftPicImageString;//积分或余额图片

@end

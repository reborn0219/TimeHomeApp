//
//  THAgeView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  封装年龄那行的控件
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import <UIKit/UIKit.h>

@interface THAgeView : UIView
/**
 *  年龄大小
 */
@property (nonatomic, strong) NSString *age;
/**
 *  年龄旁边的性别图片
 */
@property (nonatomic, strong) UIImageView *ageImage;

@end

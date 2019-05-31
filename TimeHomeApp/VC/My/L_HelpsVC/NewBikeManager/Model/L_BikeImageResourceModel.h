//
//  L_BikeImageResourceModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自行车详情图片
 */
@interface L_BikeImageResourceModel : NSObject

/**
 图片id
 */
@property (nonatomic, strong) NSString *resourceid;
/**
 图片路径
 */
@property (nonatomic, strong) NSString *resourceurl;
/**
 是否为默认图片0否 1是
 */
@property (nonatomic, strong) NSString *isdefault;

/**
 图片（自建）
 */
@property (nonatomic, strong) UIImage *image;

@end

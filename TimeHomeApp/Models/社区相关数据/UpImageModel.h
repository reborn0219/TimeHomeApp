//
//  UpImageModel.h
//  TimeHomeApp
//
//  Created by us on 16/4/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
///上传图片数据
@interface UpImageModel : NSObject

///图片地址
@property(nonatomic,copy) NSString * imgUrl;
///要上的图片数据
@property(nonatomic,copy)UIImage * img;
///上传后返回的图片id
@property(nonatomic,copy) NSString * picID;
///上传标志，1成功 2 失败 0 没有上传过
@property(nonatomic,assign) int isUpLoad;
///所在上传数组中的索引
@property(nonatomic,assign) NSInteger index;

@end

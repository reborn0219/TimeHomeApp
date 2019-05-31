//
//  LifeEditVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  发布时，显示编辑
 */
#import "BaseViewController.h"

@interface LifeEditVC : THBaseViewController

//// 0. 发布出租  1. 发布出售
@property(nonatomic,assign) int jmpCode;
///最小字数
@property(nonatomic,assign) int minLenght;
///最大字数据
@property(nonatomic,assign) int maxLenght;

/**
 *  编辑内容
 */
@property(nonatomic,strong) NSString * content;

///编辑完成传值
@property(nonatomic,copy) ViewsEventBlock viewBlock;
///默认提示信息
@property(nonatomic,copy) NSString * tishi;

@end

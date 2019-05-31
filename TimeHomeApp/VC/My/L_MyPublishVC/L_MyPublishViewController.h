//
//  L_MyPublishViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface L_MyPublishViewController : THBaseViewController

/**
 选中索引 -- 1在售 --2下架 --3其他（必传）
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 是否从推送过来
 */
@property (nonatomic, assign) BOOL isFromPush;

@end

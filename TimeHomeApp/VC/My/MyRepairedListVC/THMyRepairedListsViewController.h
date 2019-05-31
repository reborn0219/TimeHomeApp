//
//  THMyRepairedListsViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的报修列表界面
 */
#import "THBaseViewController.h"

@interface THMyRepairedListsViewController : THBaseViewController

/**
 *  推送消息中的报修单id,用于标记推送消息中报修单的数据
 */
@property(nonatomic,copy) NSArray *IdArray;
///是否是从发布过来的  YES 是
@property(nonatomic,assign) BOOL isFromRelease;
@property (nonatomic,copy)NSString *isFromMy;//0否 1是
@end

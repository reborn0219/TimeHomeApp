//
//  IsFixViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  车位是否固定选择页
 */
#import "THBaseViewController.h"

typedef void (^IndexCallBack) (NSInteger index);

@interface IsFixViewController : THBaseViewController
/**
 *  车位是否固定回调
 */
@property (nonatomic, copy) IndexCallBack indexCallBack;
/**
 *  默认选中的
 */
@property (nonatomic, assign) NSInteger indexSelect;

@end

//
//  THMySettingsVC.h
//  TimeHomeApp
//
//  Created by 李世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的信息列表界面
 */
#import "BaseViewController.h"

typedef void (^ CallBack) (void);
@interface THMySettingsVC : THBaseViewController
/**
 *  判断是否更改年龄，返回上一页刷新数据
 */
@property (nonatomic, assign) BOOL isChangeAge;

@property (nonatomic, copy) CallBack callBack;

@end

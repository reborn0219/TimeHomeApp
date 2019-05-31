//
//  THMyTagsViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的标签界面
 */
#import "BaseViewController.h"

typedef void (^ CallBack)(void);
@interface THMyTagsViewController : THBaseViewController
/**
 *  已选中的标签
 */
@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, copy) CallBack callBack;

@end

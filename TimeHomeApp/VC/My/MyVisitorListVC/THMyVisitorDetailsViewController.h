//
//  THMyVisitorDetailsViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的访客详情界面
 */
#import "BaseViewController.h"
/**
 *  网络请求
 */
#import "UserTrafficPresenter.h"

typedef void (^CallBack) (void);
@interface THMyVisitorDetailsViewController : THBaseViewController
/**
 *  访客详情
 */
@property (nonatomic, strong) UserVisitor *visitor;
/**
 *  撤销返回上一页时刷新数据
 */
@property (nonatomic, copy) CallBack callBack;

@end

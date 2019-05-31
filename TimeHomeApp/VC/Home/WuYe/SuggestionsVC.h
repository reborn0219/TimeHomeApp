//
//  SuggestionsVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/2.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  投诉建议
 */
#import "BaseViewController.h"
typedef void (^CallBack)(void);
@interface SuggestionsVC : THBaseViewController

@property (nonatomic, copy) CallBack callBack;

@end

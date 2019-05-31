//
//  THMyComplainListViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的投诉列表界面
 */
#import "THBaseViewController.h"

@interface THMyComplainListViewController : THBaseViewController

///推送消息中的投诉ID，用于标记投诉列表中那一个投诉单的消息更新
@property(nonatomic,copy) NSArray * IdArray;
@end

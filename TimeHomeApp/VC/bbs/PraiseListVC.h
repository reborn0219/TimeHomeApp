//
//  PraiseListVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 16/11/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

/**
 点赞列表
 */
@interface PraiseListVC : THBaseViewController

@property (nonatomic ,copy)NSString * postid;
@property (nonatomic ,copy)NSString * praisecount;

/**
 从推送过来判断返回到帖子详情页
 */
@property (nonatomic, assign) BOOL isFromPushMessage;
/**
 帖子url
 */
@property (nonatomic, strong) NSString *urlString;

@end

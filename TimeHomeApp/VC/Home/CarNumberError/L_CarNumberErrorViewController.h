//
//  L_CarNumberErrorViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

/**
 车牌纠错
 */
@interface L_CarNumberErrorViewController : THBaseViewController

/** 是否从推送进来 */
@property (nonatomic, assign) BOOL isFromPush;

- (void)secondBtnDidTouch;

@end

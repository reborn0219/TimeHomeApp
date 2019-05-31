//
//  ZGPicWallViewController.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/8/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

typedef void (^CallBack) (void);

@interface ZGPicWallViewController : THBaseViewController

/**
 *  上传头像后回调，重新请求数据，更新本地保存的头像URL
 */
@property (nonatomic, copy) CallBack callBack;

@end

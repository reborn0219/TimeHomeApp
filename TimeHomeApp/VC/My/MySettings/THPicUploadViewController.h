//
//  THPicUploadViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  头像上传界面
 */
#import "BaseViewController.h"
typedef void (^CallBack) (void);
@interface THPicUploadViewController : THBaseViewController
/**
 *  上传头像后回调，重新请求数据，更新本地保存的头像URL
 */
@property (nonatomic, copy) CallBack callBack;

@end

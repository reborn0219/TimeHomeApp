//
//  YYNoticeSetPresent.h
//  TimeHomeApp
//
//  Created by 世博 on 16/7/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppNoticeSet.h"
@interface YYNoticeSetPresent : NSObject

/**
 *  获得推送消息的设置
 */
+ (void)getAppMsgsetUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  保存推送消息的设置
 */
+ (void)saveAppMsgsetWithAppNoticeSet:(AppNoticeSet *)appNoticeSet UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end

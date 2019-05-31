//
//  ZSY_ChangeAreaViewController.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/11/2.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
/**
*  完善资料回调block
*
*  @param data 小区名称(全)
*/
typedef void (^MyCallBack)(NSString *communitID,NSString *communitName);
@interface ZSY_ChangeAreaViewController : THBaseViewController
/**
 *  完善资料回调block
 */
@property (nonatomic, copy) MyCallBack myCallBack;


/**
 *  判断从完善资料界面过来 type == 1表示从完善资料界面过来
 */
@property (nonatomic, assign) NSInteger type;

/**
 *是否隐藏导航右按钮
 */
@property (nonatomic, assign)BOOL isHiddenRightBar;
@property (nonatomic, copy)NSString *typeStr; //typeStr = phone 表示手机绑定页面

@end

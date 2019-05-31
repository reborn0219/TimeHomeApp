//
//  THBaseViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  自定义左上角按钮，防止与其他人的返回方法冲突,基类，创建ViewController可继承该基类
 */
#import "BaseViewController.h"
#import "BaseViewController+Redbag.h"

#import "UIImage+ImageEffects.h"


@interface THBaseViewController : BaseViewController

@property (nonatomic,assign)BOOL leftHidden;
@property (nonatomic,assign)BOOL rightHidden;

/**
 导航返回按钮设置 1.原本颜色 2.白色
 */
@property (nonatomic, assign) NSInteger leftNavButtonType;

/**
 *  返回按钮点击事件
 */
- (void)backButtonClick;
/**
 *  屏幕宽度大小
 */
- (CGFloat)cellContentViewWith;




@end

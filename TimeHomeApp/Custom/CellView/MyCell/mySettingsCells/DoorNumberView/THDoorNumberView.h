//
//  THDoorNumberView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  在我的门牌号修改和名字修改中使用过
 *
 *  @param isOpen
 *
 *  @return
 */
#import <UIKit/UIKit.h>
#import "CustomTextFIeld.h"

typedef void (^ SwitchButtonCallBack)(BOOL isOpen);
@interface THDoorNumberView : UIView 
/**
 *  上方标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  中间的输入框
 */
@property (nonatomic, strong) CustomTextFIeld *doorNumTF;
/**
 *  下方UISwitch控制开关的事件回调
 */
@property (nonatomic, strong) SwitchButtonCallBack switchButtonCallBack;
/**
 *  下方UISwitch控制开关控件
 */
@property (nonatomic, strong) UISwitch *switchButton;

@end

//
//  THMyRequiredTVCStyle5.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的报修自定义cell5
 */
#import "THABaseTableViewCell.h"
#import "SignsView.h"

@interface THMyRequiredTVCStyle5 : THABaseTableViewCell <UITextViewDelegate>
/**
 *  评价选择按钮点击事件回调
 */
@property (nonatomic, copy) ViewsEventBlock buttonSelectEventBlock;
/**
 *  输入框
 */
@property (nonatomic, strong) SignsView *signsView;

@end

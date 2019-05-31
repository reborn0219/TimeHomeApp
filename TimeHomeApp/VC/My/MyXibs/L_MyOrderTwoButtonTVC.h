//
//  L_MyOrderTwoButtonTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TwoButtonDidClickBlock)(NSInteger index);
@interface L_MyOrderTwoButtonTVC : UITableViewCell

/**
 按钮点击回调
 */
@property (nonatomic, copy) TwoButtonDidClickBlock twoButtonDidClickBlock;

@end

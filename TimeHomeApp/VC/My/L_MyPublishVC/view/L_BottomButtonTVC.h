//
//  L_BottomButtonTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ThreeButtonDidClickBlock)(NSInteger index);
/**
 底部按钮
 */
@interface L_BottomButtonTVC : UITableViewCell

/** 1==下架  2==重新发布  其他隐藏 */
@property (nonatomic, assign) NSInteger type;
/** 按钮点击回调 */
@property (nonatomic, copy) ThreeButtonDidClickBlock threeButtonDidClickBlock;

@end

//
//  L_MyInfoThreeButtonTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ThreeButtonDidTouchCallBack)(NSInteger index);
@interface L_MyInfoThreeButtonTVC : UITableViewCell

/**
 三个按钮点击回调
 */
@property (nonatomic, copy) ThreeButtonDidTouchCallBack threeButtonDidTouchCallBack;

@end

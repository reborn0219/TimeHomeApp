//
//  L_AddBikeFooterView.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TwoButtonDidTouchCallBack)(NSInteger buttonIndex);
@interface L_AddBikeFooterView : UIView

@property (nonatomic, copy) TwoButtonDidTouchCallBack twoButtonDidTouchCallBack;

+(L_AddBikeFooterView *)instanceAddBikeFooterView;

@end

//
//  PAChooseLicensePlateNumberView.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAChooseLicensePlateNumberView : UIView
///动画弹出高度
@property (nonatomic, assign) CGFloat popupAnimationDisplacement;
@property (nonatomic, copy) UpDateViewsBlock block;
-(void)popupKeyBoard:(BOOL)show;

@end

//
//  CertificationPopupView.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/3/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertificationPopupView : UIViewController
@property (nonatomic, copy) ViewsEventBlock callBlock;
@property (nonatomic, assign) NSInteger type;
- (void)showVC:(UIViewController *)parent event:(ViewsEventBlock)eventCallBack;

@end

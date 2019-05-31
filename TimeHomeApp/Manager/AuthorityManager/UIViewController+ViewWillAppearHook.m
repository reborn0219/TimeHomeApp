//
//  UIViewController+ViewWillAppearHook.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/29.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UIViewController+ViewWillAppearHook.h"

@implementation UIViewController (ViewWillAppearHook)

+ (void)load {
    // 交换实现viewWillAppear
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillAppear:)),class_getInstanceMethod(self, @selector(tracking_viewWillAppear:)));
}

#pragma mark - Method Swizzling

- (void)tracking_viewWillAppear:(BOOL)animated {
    [self tracking_viewWillAppear:animated];
    
    NSLog(@"权限控制####页面显示");
}

@end

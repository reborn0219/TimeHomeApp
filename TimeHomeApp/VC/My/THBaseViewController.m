//
//  THBaseViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface THBaseViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation THBaseViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createBackBarButton];
    _leftHidden = NO;
    _rightHidden = NO;

    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    // 设置文本与图片的偏移量
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(5, 0)
//                                                         forBarMetrics:UIBarMetricsDefault];
    // 设置文本的属性
//    NSDictionary *attributes = @{UITextAttributeFont:[UIFont systemFontOfSize:16],
//                                 UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]};
//    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}
//这个方法是在手势将要激活前调用：返回YES允许侧滑手势的激活，返回NO不允许侧滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //首先在这确定是不是我们需要管理的侧滑返回手势
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
        if(self.navigationController.childViewControllers.count == 1)
        {
            return NO;
        }
        
        return YES;
    }
    
    //这里就是非侧滑手势调用的方法啦，统一允许激活
    return YES;
}

- (void)createBackBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);

    UIImage *image = [UIImage imageNamed:@"返回"];
    [button setBackgroundImage:[image imageWithColor:TITLE_TEXT_COLOR] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = backButton;

}

- (void)setLeftNavButtonType:(NSInteger)leftNavButtonType {
    
    _leftNavButtonType = leftNavButtonType;
    
    if (leftNavButtonType == 1) {
        
        UIButton *button = self.navigationItem.leftBarButtonItem.customView;
        UIImage *image = [UIImage imageNamed:@"返回"];
        [button setBackgroundImage:[image imageWithColor:TITLE_TEXT_COLOR] forState:UIControlStateNormal];
        
    }else if (leftNavButtonType == 2) {
        
        UIButton *button = self.navigationItem.leftBarButtonItem.customView;
        UIImage *image = [UIImage imageNamed:@"返回"];
        [button setBackgroundImage:[image imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
    }
    
}


- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width-14;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height-14;
    }
    return width;
}


/**
 * 隐藏导航左按钮
 **/
- (void)setLeftHidden:(BOOL)leftHidden {
    [self.navigationItem setHidesBackButton:YES];
    
    _leftHidden = leftHidden;
    if (leftHidden == YES) {
//        [self.navigationItem.backBarButtonItem setTitle:@""];
        
        self.navigationItem.leftBarButtonItem = nil;

    }else {
        
        [self createBackBarButton];
    }
    
}

/**
 * 隐藏导航右按钮
 **/
- (void)setRightHidden:(BOOL)rightHidden {
    
    if (rightHidden == YES) {
        
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationItem.hidesBackButton = YES;
    }
}

@end

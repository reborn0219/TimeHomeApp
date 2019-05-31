//
//  L_GarageDaysPopVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_GarageDaysPopVC.h"
#import "L_GarageDayButton.h"

@interface L_GarageDaysPopVC () <UIGestureRecognizerDelegate>
{
    NSString *selectedDays;
    NSMutableArray *selectDaysArray;
}
@end

@implementation L_GarageDaysPopVC

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
    
    [self setupSevenButtons];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissVC)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}
#pragma mark - 设置七天按钮
- (void)setupSevenButtons {
    
    selectDaysArray = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    
    if (![XYString isBlankString:selectedDays]) {
        NSArray *tempArr = [selectedDays componentsSeparatedByString:@","];
        
        for (NSString *dayStr in tempArr) {
            
            if (dayStr.integerValue > 0 && dayStr.integerValue < 8) {
                [selectDaysArray replaceObjectAtIndex:dayStr.integerValue-1 withObject:dayStr];
            }
            
        }
        
    }
    
    CGFloat buttonW = 30.f;
    CGFloat margin = (self.dayBgView.frame.size.width - (buttonW * 7)) / 8.f;
    
    for (int i = 0; i < 7; i++) {
        
        L_GarageDayButton *button = [L_GarageDayButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 11;
        if ([selectDaysArray[i] integerValue] == 0) {
            button.isDaySelected = NO;
        }else {
            button.isDaySelected = YES;
        }
        [button setTitle:[NSString stringWithFormat:@"%@",[XYString NSNumberToString:i + 1]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sevenButtonsDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.dayBgView addSubview:button];
        
        button.sd_layout.centerYEqualToView(self.dayBgView).leftSpaceToView(self.dayBgView,margin + (margin + buttonW) * i).widthIs(buttonW).heightEqualToWidth();
        [button setSd_cornerRadiusFromWidthRatio:@0.5];
        
    }
    
}

- (void)sevenButtonsDidTouch:(L_GarageDayButton *)button {
    
    button.isDaySelected = !button.isDaySelected;
    
    if (button.isDaySelected) {
        
        [selectDaysArray replaceObjectAtIndex:button.tag-11 withObject:[NSString stringWithFormat:@"%ld",button.tag-10]];
        
    }else {
        
        [selectDaysArray replaceObjectAtIndex:button.tag-11 withObject:@"0"];
        
    }
    
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.dayBgView]) {
        return NO;
    }
    return YES;
}
#pragma mark - 按钮点击事件
- (IBAction)dayButtonsDidTouch:(UIButton *)sender {
    
    if (sender.tag == 3) {
        [selectDaysArray removeObject:@"0"];
        selectedDays = [selectDaysArray componentsJoinedByString:@","];
        
        //确定
        if (self.daysConfirmButtonCallBack) {
            self.daysConfirmButtonCallBack(selectedDays);
        }
        
    }
    
    [self dismissVC];
    
}

#pragma mark - 返回实例
+ (L_GarageDaysPopVC *)getInstance {
    L_GarageDaysPopVC * garageDaysPopVC= [[L_GarageDaysPopVC alloc] initWithNibName:@"L_GarageDaysPopVC" bundle:nil];
    return garageDaysPopVC;
}

#pragma mark - 显示
- (void)showVC:(UIViewController *)parent withDay:(NSString *)days cellEvent:(DaysConfirmButtonCallBack)eventCallBack {
    
    selectedDays = [XYString IsNotNull:days];
    
    self.daysConfirmButtonCallBack = eventCallBack;
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [parent presentViewController:self animated:NO completion:^{
        
    }];
    
}

#pragma mark - 隐藏显示
-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

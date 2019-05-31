//
//  L_GarageTimePopVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ConfirmButtonCallBack)(NSString *timeString);

@interface L_GarageTimePopVC : BaseViewController

@property (nonatomic, copy) ConfirmButtonCallBack confirmButtonCallBack;

@property (weak, nonatomic) IBOutlet UIView *timeBgView;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

/**
 *  返回实例
 */
+ (L_GarageTimePopVC *)getInstance;

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withHour:(NSString *)hour withMinute:(NSString *)minute cellEvent:(ConfirmButtonCallBack)eventCallBack;

@end

//
//  ZSY_PickerViewVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/20.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSY_PickerViewVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic,copy)ViewsEventBlock block;
+(instancetype)sharePickerViewVC;
-(void)show:(UIViewController * )VC;
@property (weak, nonatomic) IBOutlet UIView *redView;
-(void)dismiss;
@end

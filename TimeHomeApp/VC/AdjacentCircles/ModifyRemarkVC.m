//
//  ModifyRemarkVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/4/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
#import "ModifyRemarkVC.h"
#import "UserInfoMotifyPresenters.h"

@interface ModifyRemarkVC ()<UITextFieldDelegate>

@end

@implementation ModifyRemarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _remarkTF.delegate = self;
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}
-(void)rightBarAction:(id)sender
{
    @WeakObj(self)
   
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];

    [UserInfoMotifyPresenters saveRemarkNameUserID:_userID name:self.remarkTF.text UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            if(resultCode == SucceedCode)
            {
                
                [selfWeak showToastMsg:data Duration:2.0f];
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
        });
        
      
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _nikeNameLb.text = [NSString stringWithFormat:@"昵称：%@",_nikeName];
    if (![XYString isBlankString:_remarkname]) {
        _remarkTF.text = _remarkname;

    }
}
- (IBAction)textChanged:(id)sender {
    
    UITextField * textField = sender;
    NSInteger number = [textField.text length];
    UITextRange * selectedRange = textField.markedTextRange;
    
    if(selectedRange == nil || selectedRange.empty){
        
        if (number >=10) {
            [self showToastMsg:@"字符个数不能大于10" Duration:2.5f];
            textField.text = [textField.text substringToIndex:10];
        }
        
    }
}

@end

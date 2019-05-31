//
//  L_NewBikeForthTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeForthTVC.h"

@interface L_NewBikeForthTVC ()<UITextFieldDelegate>



@end

@implementation L_NewBikeForthTVC

- (void)setCodeString:(NSString *)codeString {
    
    _codeString = codeString;
    
    NSLog(@"codeString==%@",codeString);
    _textField.text = codeString;
    
}

/**
 扫描或删除按钮点击
 */
- (IBAction)scanButtonDidTouch:(UIButton *)sender {
    
    /** 1.2扫描 3删除 */
    if (self.allButtonDidTouchBlock) {
        self.allButtonDidTouchBlock(sender.tag);
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([XYString isBlankString:textField.text]) {
        textField.text = @"";
    }
    
    if (self.tFTextCallBack) {
        self.tFTextCallBack(textField.text);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _textField.delegate = self;
    
    [_textField addTarget:self action:@selector(devicenoTFEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)devicenoTFEditingChanged:(UITextField *)textField {
    
    UITextRange * selectedRange = textField.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(textField.text.length >= 24)
        {
            textField.text = [textField.text substringToIndex:24];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

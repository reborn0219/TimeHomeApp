//
//  L_CertifyAddBaseTVC2.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CertifyAddBaseTVC2.h"

@interface L_CertifyAddBaseTVC2 () <UITextFieldDelegate>

@end

@implementation L_CertifyAddBaseTVC2

- (void)textFieldEditingChanged:(UITextField *)textField {
    
    if (_type == 1) {
        UITextRange * selectedRange = textField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(textField.text.length >= 20)
            {
                textField.text = [textField.text substringToIndex:20];
            }
        }
    }
    
    if (_type == 2) {
        UITextRange * selectedRange = textField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(textField.text.length >= 6)
            {
                textField.text = [textField.text substringToIndex:6];
            }
        }
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.textFieldBlock) {
        self.textFieldBlock(textField.text, nil, 0);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _right_TF.delegate = self;
    
    [_right_TF addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

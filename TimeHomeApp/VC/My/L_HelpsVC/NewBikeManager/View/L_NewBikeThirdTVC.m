//
//  L_NewBikeThirdTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeThirdTVC.h"

@interface L_NewBikeThirdTVC () <UITextFieldDelegate>

@end

@implementation L_NewBikeThirdTVC

- (void)setModel:(L_BikeListModel *)model {
    _model = model;
}

- (void)setType:(NSInteger)type {
    
    _type = type;
    
    if (type == 1) {
        self.rightButtonLayoutConstraint.constant = 60;

    }
    if (type == 2) {
        self.rightButtonLayoutConstraint.constant = 0;

    }
    
}

/**
 选择按钮点击
 */
- (IBAction)selectButtonDidTouch:(UIButton *)sender {
    NSLog(@"选择");
    if (self.buttonDidTouchBlock) {
        self.buttonDidTouchBlock();
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.textFieldBlock) {
        self.textFieldBlock(textField.text);
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];

    _textField.delegate = self;
    
    [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)textFieldEditingChanged:(UITextField *)textField {
    
    if (_type == 1) {
        UITextRange * selectedRange = textField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(textField.text.length >= 10)
            {
                textField.text = [textField.text substringToIndex:10];
            }
        }
    }
    
    if (_type == 2) {
        UITextRange * selectedRange = textField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(textField.text.length >= 5)
            {
                textField.text = [textField.text substringToIndex:5];
            }
        }
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

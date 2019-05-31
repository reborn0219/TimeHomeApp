//
//  THMyRequiredTVCStyle5.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyRequiredTVCStyle5.h"
#import "THSelectButton.h"

@implementation THMyRequiredTVCStyle5
{
    NSArray *faceImages;
    NSArray *titles;
    NSInteger buttonSelected;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        faceImages = @[@"维修评价_非常满意",@"维修评价_满意",@"维修评价_不满意"];
        titles = @[@"非常满意",@"满意",@"不满意"];
        buttonSelected = 1;
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    CGFloat buttonWidth = (SCREEN_WIDTH-2*7-15*2)/3;
    for (int i = 0; i < 3; i++) {
        THSelectButton *button= [THSelectButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonWidth*i+15, 0, buttonWidth, 60);
        
        button.faceImageView.image = [UIImage imageNamed:faceImages[i]];
        button.rightLabel.text = titles[i];
        if (i == 0) {
            button.dotImageView.image = [UIImage imageNamed:@"维修评价_已选中"];
            button.selected = YES;
        }else {
            button.dotImageView.image = [UIImage imageNamed:@"维修评价_未选中"];
            button.selected = NO;
        }
        button.tag = i+1;
        [button addTarget:self action:@selector(threeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        if (i == 1) {
            
            button.titleViewAligment = TitleViewAligmentMiddle;
        }
        if (i == 2) {
            button.titleViewAligment = TitleViewAligmentRight;
        }
    }
    
    _signsView = [[SignsView alloc]initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH-14-2*10, 135)];
    _signsView.signTextView.placeHolder.text = @"请对本次维修进行评价";
    _signsView.signTextView.delegate = self;
    _signsView.countsLabel.text = [NSString stringWithFormat:@"0/100"];
    [self.contentView addSubview:_signsView];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _signsView.signTextView.placeHolder.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    UITextRange * selectedRange = textView.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        
        if(textView.text.length>=100)
        {
            textView.text=[textView.text substringToIndex:100];
        }
        _signsView.countsLabel.text = [NSString stringWithFormat:@"%ld/100",(unsigned long)textView.text.length];
        
    }
    
}
//
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//
//
//    if (![text isEqualToString:@""]){
//
//        _signsView.signTextView.placeHolder.hidden = YES;
//
//    }
//    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
//
//        _signsView.signTextView.placeHolder.hidden = NO;
//
//    }
//
//    NSString * toBeString = [ _signsView.signTextView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
//    _signsView.countsLabel.text = [NSString stringWithFormat:@"%ld/100",(unsigned long)toBeString.length];
//    
//    if (toBeString != 0) {
//        _signsView.signTextView.placeHolder.hidden = YES;
//    }
//
//    if (_signsView.signTextView == textView)  //判断是否时我们想要限定的那个输入框
//    {
//        if ([toBeString length] > 100) { //如果输入框内容大于100
//            textView.text = [toBeString substringToIndex:100];
//            _signsView.countsLabel.text = [NSString stringWithFormat:@"%ld/100",(unsigned long)textView.text.length];
//            return NO;
//        }
//    }
//    return YES;
//
//}


- (void)threeButtonClick:(THSelectButton *)button {
    
    if (button.tag == buttonSelected) {
        return;
    }
    button.dotImageView.image = [UIImage imageNamed:@"维修评价_已选中"];
    
    THSelectButton *lastButton = (THSelectButton *)[self viewWithTag:buttonSelected];
    lastButton.dotImageView.image = [UIImage imageNamed:@"维修评价_未选中"];

    buttonSelected = button.tag;
    
    if (self.buttonSelectEventBlock) {
        self.buttonSelectEventBlock(nil,nil,button.tag);
    }
    
}

@end

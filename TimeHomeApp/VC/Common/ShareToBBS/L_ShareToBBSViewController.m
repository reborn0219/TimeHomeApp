//
//  L_ShareToBBSViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/11/2.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ShareToBBSViewController.h"
#import "BBSMainPresenters.h"

#define Share_MAX_TextViewLength 20

@interface L_ShareToBBSViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;
@property (weak, nonatomic) IBOutlet UILabel *shareTitleLabel;

@end

@implementation L_ShareToBBSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shareTitleLabel.text = self.shareTitle;
    [_shareImageView sd_setImageWithURL:[NSURL URLWithString:self.shareImg] placeholderImage:PLACEHOLDER_IMAGE];
    
    _textView.delegate = self;
    
    [_textView becomeFirstResponder];
    
    [self setupNavBtn];

}

- (void)setupNavBtn {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 24);
    rightBtn.backgroundColor = kNewRedColor;
    rightBtn.layer.cornerRadius = 5.;
    rightBtn.titleLabel.font = DEFAULT_FONT(14);
    [rightBtn setTitle:@"发表" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
}

- (void)rightBtnDidClick {
    
    NSLog(@"发表");
    
    [_textView resignFirstResponder];
    
    NSString *content = [XYString IsNotNull:_textView.text];
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters postNews:@"9" title:self.shareTitle andContent:content andPicids:self.shareImg andRedtype:@"-1" andPaytype:@"-1" andRedallmoney:@"0" andRedallcount:@"0" andRedtheway:@"0" andTagsname:@"" andOneMoney:@"" gotourl:self.shareUrl updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

        dispatch_async(dispatch_get_main_queue(), ^{

            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            if (resultCode == SucceedCode) {
                //成功
                [self showToastMsg:@"分享成功" Duration:3.0];
                [self.navigationController popViewControllerAnimated:YES];

            }else {
                //失败
                [self showToastMsg:data Duration:3.0];

            }

        });
    }];
    
}

#pragma mark - UITextViewDelegate

// 计算剩余可输入字数 超出最大可输入字数，就禁止输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 设置占位文字是否隐藏
    if(![text isEqualToString:@""]) {
        [_placeHolder setHidden:YES];
    }
    if([text isEqualToString:@""] && range.length == 1 && range.location == 0) {
        [_placeHolder setHidden:NO];
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < Share_MAX_TextViewLength) {
            return YES;
        }else{
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = Share_MAX_TextViewLength - comcatstr.length;
    if (caninputlen >= 0){
        return YES;
    }else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0, MAX(len, 0)};
        if (rg.length > 0){
            // 因为我的是不需要输入表情，所以没有计算表情的宽度
            NSString *s =@"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }else{
                __block NSInteger idx = 0;
                __block NSString  *trimString =@"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
                    if (idx >= rg.length) {
                        *stop =YES;//取出所需要就break，提高效率
                        return ;
                    }
                    trimString = [trimString stringByAppendingString:substring];
                    idx++;
                }];
                s = trimString;
            }
            
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setAttributedText: [self textViewAttributedStr:[textView.text stringByReplacingCharactersInRange:range withString:[text substringWithRange:rg]]]];
            //既然是超出部分截取了，哪一定是最大限制了。
//            _firstView.countLabel.text = [NSString stringWithFormat:@"%d/%ld",200,(long)MAX_TextViewLength];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > Share_MAX_TextViewLength) {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:Share_MAX_TextViewLength];
        [textView setAttributedText: [self textViewAttributedStr:s]];
        existTextNum = Share_MAX_TextViewLength;
    }
    //不让显示负数
//    _firstView.countLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,existTextNum),MAX_TextViewLength];
    
    //不支持系统表情的输入
    //    if ([self isStringContainsEmoji:textView.text]) {
    //        [self showToastMsg:@"不支持输入表情，请重新输入!" Duration:3.0];
    //        _firstView.contentTextView.text = [_firstView.contentTextView.text substringToIndex:textView.text.length - 2];
    //    }
    
    if ([XYString isBlankString:textView.text]) {
        _placeHolder.hidden = NO;
    }else {
        _placeHolder.hidden = YES;
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        _placeHolder.hidden = YES;
    } else {
        _placeHolder.hidden = NO;
    }
    return YES;
}

- (BOOL)isStringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
    
}

// 返回文本格式
- (NSAttributedString *)textViewAttributedStr:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end

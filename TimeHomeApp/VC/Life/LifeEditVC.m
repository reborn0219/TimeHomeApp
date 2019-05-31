//
//  LifeEditVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LifeEditVC.h"

@interface LifeEditVC ()<UITextViewDelegate>

/**
 *  编辑文本
 */
@property (weak, nonatomic) IBOutlet UITextView *TV_Content;

@end

@implementation LifeEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.minLenght=10;
    self.maxLenght=500;
//    if(_jmpCode==0)
//    {
//        self.tishi=@"交通配置等，至少10字";
//    }
//    else if(_jmpCode==1)
//    {
//        self.tishi=@"小区环境等，至少10字";
//    }
    self.TV_Content.text=self.tishi;
    if(self.content!=nil||self.content.length>0)
    {
        self.TV_Content.text=self.content;
    }
    self.TV_Content.delegate=self;
    self.TV_Content.textColor=UIColorFromRGB(0x8e8e8e);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  完成事件处理
 *
 *  @param sender
 */
- (IBAction)btn_OkEvent:(UIButton *)sender {
    if(self.TV_Content.text.length<self.minLenght)
    {
        [self showToastMsg:[NSString stringWithFormat:@"不能少于%d个字",self.minLenght] Duration:5.0];
        return;
    }
    if(self.viewBlock)
    {
        self.content=self.TV_Content.text;
        self.viewBlock(self.content,self.TV_Content,0);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark ------------UITextViewDelegate实现-----------
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
//    
//    if ([@"\n" isEqualToString:text] == YES) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
-(void)textViewDidBeginEditing:(nonnull UITextView *)textView
{
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height- ( textView.contentOffset.y + textView.bounds.size.height- textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
    if ([self.TV_Content.text isEqualToString:self.tishi]) {
        self.TV_Content.text=@"";
    }
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    UITextRange * selectedRange = textView.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if (self.TV_Content.text.length>self.maxLenght) {
            self.TV_Content.text=[textView.text substringToIndex:self.maxLenght];
            [self showToastMsg:@"输入内容超过500字了" Duration:5.0];
            [self showToastMsg:[NSString stringWithFormat:@"输入内容超过%d字了",self.maxLenght] Duration:5.0];
            return;
        }
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

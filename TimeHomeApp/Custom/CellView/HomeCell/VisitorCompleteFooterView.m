//
//  VisitorCompleteFooterView.m
//  TimeHomeApp
//
//  Created by us on 16/3/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "VisitorCompleteFooterView.h"

@implementation VisitorCompleteFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btn_Send:(UIButton *)sender {
    if (self.viewEventCallBack) {
        self.viewEventCallBack(nil,sender,0);
    }
    if(self.delegate)
    {
        [self.delegate btnEvent];
    }
}
+(VisitorCompleteFooterView *)instanceFooterView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"VisitorCompleteFooterView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
///事件回调
-(void)setShareEventCallBack:(ViewsEventBlock) viewEventCallBack
{
    
    self.viewEventCallBack=viewEventCallBack;
}
@end

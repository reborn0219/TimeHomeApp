//
//  NothingnessView.m
//  TimeHomeApp
//
//  Created by us on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NothingnessView.h"

@implementation NothingnessView

- (IBAction)checkButtonDidTouch:(UIButton *)sender {
    NSLog(@"查看已失效券");
    if (self.checkButtonCallBack) {
        self.checkButtonCallBack();
    }
    
}


/**
*跳转事件
*
*  @param sender sender description
*/
- (IBAction)btn_GoEvent:(UIButton *)sender {
    
    if (self.eventCallBack) {
        self.eventCallBack(nil,sender,0);
    }
    
}
/**
 *  刷新事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_RefreshEvent:(UIButton *)sender {
    if (self.eventCallBack) {
        self.eventCallBack(nil,sender,1);
    }
}


/**
 *  获取实例
 *
 *  @return
 */
+(NothingnessView *)getInstanceView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"NothingnessView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end

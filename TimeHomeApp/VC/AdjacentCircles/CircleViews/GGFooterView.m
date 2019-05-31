//
//  GGFooterView.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GGFooterView.h"

@implementation GGFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.imgV.userInteractionEnabled = YES;
    UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picTouchAction)];
    [self.imgV addGestureRecognizer:gest];
    
}
-(void)picTouchAction
{
    NSLog(@"--------img点击");
    self.img_block(nil,nil,_type);
}
- (IBAction)closeAction:(id)sender {
    
    NSLog(@"9999----9999----%ld",_type);
    
    self.block(nil,nil,_type);
}
@end

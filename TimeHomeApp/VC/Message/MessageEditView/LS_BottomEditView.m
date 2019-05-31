//
//  LS_BottomEditView.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_BottomEditView.h"

@implementation LS_BottomEditView

-(void)editBlock:(AlertBlock)block
{
    _alertblock = block;
    _isAllSelect = NO;
}
- (IBAction)clearBtnAction:(id)sender {
    
    if (_alertblock) {
        _alertblock(1);
    }
}

- (IBAction)allSelectBtnAction:(id)sender {
    
    
    _isAllSelect = !_isAllSelect;

    if (_isAllSelect) {
        [_selImgView setImage:[UIImage imageNamed:@"ls_duigou"]];
    }else
    {
        [_selImgView setImage:[UIImage imageNamed:@"ls_tuoyuan"]];

    }
    
   
    if (_alertblock) {
        _alertblock(0);
    }
}
@end

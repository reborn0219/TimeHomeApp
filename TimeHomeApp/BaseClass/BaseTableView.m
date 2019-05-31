//
//  BaseTableView.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

#pragma mark ------无数据或加载失败视图显示------
/**
 *  显示无数据或加载失改视图
 *
 *  @param NoContentType type 无数据占位图的类型
 *  @param msg           msg  显示无数据提示
 */
- (void)showNothingnessViewWithType:(NoContentType)type Msg:(NSString *)msg eventCallBack:(ViewsEventBlock) callBack {
    
    if(!self.nothingnessView) {
        self.nothingnessView = [NothingnessView getInstanceView];
    }
    self.nothingnessView.view_SubBg.hidden=YES;
    
    self.nothingnessView.lab_Clues.text = [XYString IsNotNull:msg];
    self.nothingnessView.eventCallBack  = callBack;
    
    switch (type) {
        case NoContentTypeNetwork:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-加载失败"]];
        }
            break;
        case NoContentTypeData:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-暂无数据"]];
        }
            break;
        case NoContentTypePublish:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-无帖子"]];
        }
            break;
        case NoContentTypeBikeManager:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-二轮车无数据"]];
        }
            break;
        case NoContentTypeOnlineService:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-在线报修"]];
        }
            break;
        case NoContentTypeMyRedList:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"开门红包-暂无现金"]];
        }
            break;
        case NoContentTypeMyCouponList:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"我的券-暂无券"]];
        }
            break;
        default:
            break;
    }
    
    [self.superview addSubview:self.nothingnessView];
    
    [self.nothingnessView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        
    }];
}

/**
 *  显示无数据或加载失改视图有按钮和事件处理
 *
 *  @param NoContentType type 无数据占位图的类型
 *  @param msg      msg 显示无数据提示
 *  @param subMsg   subMsg 显示无数据子提示
 *  @param title    title 按钮文字
 *  @param callBack callBack 事件回调
 */
-(void)showNothingnessViewWithType:(NoContentType)type Msg:(NSString *)msg SubMsg:(NSString *) subMsg btnTitle:(NSString *)title eventCallBack:(ViewsEventBlock) callBack {
    
    [self showNothingnessViewWithType:type Msg:msg eventCallBack:callBack];
    self.nothingnessView.view_SubBg.hidden=NO;
    self.nothingnessView.lab_subClues.text = [XYString IsNotNull:subMsg];
    self.nothingnessView.lab_subClues.textAlignment = NSTextAlignmentCenter;
    [self.nothingnessView.btn_Go setTitle:title forState:UIControlStateNormal];
    if ([XYString isBlankString:title]) {
        self.nothingnessView.btn_Go.hidden = YES;
    }else {
        self.nothingnessView.btn_Go.hidden = NO;
    }
    
}

- (void)hiddenNothingView {
    if (self.nothingnessView) {
        [self.nothingnessView removeFromSuperview];
        self.nothingnessView = nil;
    }
}

@end

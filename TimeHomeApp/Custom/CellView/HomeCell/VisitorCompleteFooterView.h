//
//  VisitorCompleteFooterView.h
//  TimeHomeApp
//
//  Created by us on 16/3/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 * 访客通行申请完成页脚
 */
#import <UIKit/UIKit.h>

@protocol FooterEventDelegate <NSObject>

-(void)btnEvent;

@end


@interface VisitorCompleteFooterView : UITableViewHeaderFooterView

/**
 *  说明内容
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Description;

@property (weak, nonatomic) IBOutlet UIButton *btn_SendToVisitor;
@property(copy,nonatomic) ViewsEventBlock viewEventCallBack;

@property(weak,nonatomic) id <FooterEventDelegate> delegate;

/**
 *  通过xib返回实例
 *
 *  @return return value VisitorCompleteFooterView 对象
 */
+(VisitorCompleteFooterView *)instanceFooterView;

///事件回调
-(void)setShareEventCallBack:(ViewsEventBlock) viewEventCallBack;
@end

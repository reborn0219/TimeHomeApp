//
//  MsgAlertView.h
//  TimeHomeApp
//
//  Created by us on 16/4/20.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgAlertView : UIView

@property(nonatomic,copy) ViewsEventBlock eventBlock;

////显示对话框
-(void)showMsgViewForMsg:(NSString *)msg btnOk:(NSString *)btnOkText btnCancel:(NSString *)btnCancelText blok:(ViewsEventBlock)blok;

/**
 *  单例方法
 */
SYNTHESIZE_SINGLETON_FOR_HEADER(MsgAlertView);
@end

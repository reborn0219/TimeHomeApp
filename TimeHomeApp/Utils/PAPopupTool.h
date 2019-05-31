//
//  PAPopupTool.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PAPopupTool : NSObject

/**
 弹框显示次数默认值为 1 注：0 不显示  1...显示   需要控制显示次数时做减法即可 
 */
@property (nonatomic, copy) NSNumber *popupNumbers;
+(instancetype)sharePAPopupTool;
///无网络输入框
-(void)showNotNetworkView;
///弹出省份键盘输入
-(void)showProvincesKeyBoard:(UpDateViewsBlock)block;
///隐藏键盘操作
-(void)popupKeyBoard:(BOOL)show;

-(void)dissmissView;
@end

//
//  SignatureView.h
//  TimeHomeApp
//
//  Created by us on 16/4/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FirstCallBack)(void);

@protocol SignatureViewDelegate <NSObject>

-(void)finshedView;

@end

@interface SignatureView : UIView

@property (nonatomic, copy) FirstCallBack firstCallBack;
@property(nonatomic,weak) id <SignatureViewDelegate> delegate;

///只显示升级
-(void)showShengJi;

///显示视图
-(void)showViewForText:(NSString *)text  Integral:(NSString *)integral flag:(int )flag;
///取消视图显示
-(void)dismissView;

@end

//
//  CustomCalloutView.h
//  QYgaosu
//
//  Created by us on 15/7/27.
//  Copyright © 2015年 uskj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kTitleWidth         200
#define kArrorHeight        10

@interface CustomCalloutView : UIView

@property (nonatomic, copy) NSString *title; //标题
@property(nonatomic,assign ) int height;//高度

@property (nonatomic, strong) UILabel *titleLabel;

//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text;

@end

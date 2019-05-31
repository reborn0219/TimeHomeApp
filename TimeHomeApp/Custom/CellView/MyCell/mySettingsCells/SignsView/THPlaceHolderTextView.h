//
//  THPlaceHolderTextView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  封装的带有placeholder的TextView
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import <UIKit/UIKit.h>

@interface THPlaceHolderTextView : UITextView

@property (nonatomic, strong) UILabel *placeHolder;

@end

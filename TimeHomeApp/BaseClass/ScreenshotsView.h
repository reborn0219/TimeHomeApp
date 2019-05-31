//
//  ScreenshotsView.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/9.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenshotsView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (nonatomic,copy)ViewsEventBlock block;
@property (weak, nonatomic) IBOutlet UIView *borderView;
+(ScreenshotsView *)instanceScreenshotsView;
@end

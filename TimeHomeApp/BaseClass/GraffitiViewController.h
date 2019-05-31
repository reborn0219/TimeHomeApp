//
//  GraffitiViewController.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/9.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaiN_DrawView.h"
@interface GraffitiViewController : UIViewController
@property (weak, nonatomic) IBOutlet RaiN_DrawView *drawView;
@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UIButton *yellowBtn;
@property (weak, nonatomic) IBOutlet UIButton *orangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinkBtn;
@property (weak, nonatomic) IBOutlet UIButton *blueBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@property (nonatomic,strong)UIImage *image;
@property (nonatomic,copy)NSString *type;//选择的操作类型 0意见反馈 1分享页面
@end

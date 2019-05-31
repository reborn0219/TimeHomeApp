//
//  THIndicatorVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface THIndicatorVC : UIView

/**
 显示信息
 */
@property (weak, nonatomic) IBOutlet UILabel *msg_Label;

/**
 *  gif图展示
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Gif;
/**
 *  背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *view_BgView;
///是否在显示
@property(nonatomic,assign) BOOL isStarting;
/**
 *  动画停止
 */
-(void)stopAnimating;
/**
 * 动画启动
 */
-(void)startAnimating:(UIViewController *) vc;



/**
 *  单例方法
 */
SYNTHESIZE_SINGLETON_FOR_HEADER(THIndicatorVC);

/**
 *  获取实例
 *
 *  @return return value description
 */
+(THIndicatorVC *)getInstance;


@end

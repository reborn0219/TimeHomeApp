//
//  CommonAlertVC.h
//  TimeHomeApp
//
//  Created by us on 16/2/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  通用提示对话框
 *
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//添加车牌事件类型
typedef NS_ENUM(NSInteger,AlertEventCodeType)
{
    ///确认
    ALERT_OK=1000,
    ///取消
    ALERT_CANCEL
};

@interface CommonAlertVC : UIViewController

/**
 *  背景view
 */
@property (weak, nonatomic) IBOutlet UIView *view_BgView;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  提示内容
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_ContentText;
/**
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Cancel;
/**
 *  确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Ok;
/**
 *  事件处理回调
 */
@property(copy,nonatomic) ViewsEventBlock eventCallBack;

/**
 *  隐藏显示
 */
-(void)dismissAlert;
/**
 *  显示
 *
 *  @param parent <#parent description#>
 */
-(void)ShowAlert:(UIViewController *)parent;


/**
 *  显示
 *
 *  @param parent    parent 父VC
 *  @param title     title 提示标题
 *  @param msg       msg  提示内容
 *  @param text      左Button文字
 *  @param otherText 右Button文字
 */
-(void)ShowAlert:(UIViewController *)parent Title:(NSString *) title Msg:(NSString *)msg oneBtn:(NSString *)text otherBtn:(NSString *)otherText;

/**
 *  显示
 *
 *  @param parent              parent 父VC
 *  @param title               title 提示标题
 *  @param attributeMsg        attributeMsg  提示内容
 *  @param text                左Button文字
 *  @param otherText           右Button文字
 */
-(void)ShowAlert:(UIViewController *)parent Title:(NSString *) title AttributeMsg:(NSMutableAttributedString *)attributeMsg oneBtn:(NSString *)text otherBtn:(NSString *)otherText;

/**
 *  获取实例
 *
 *  @return return value description
 */
+(CommonAlertVC *)getInstance;
/**
 *  单例方法
 */
SYNTHESIZE_SINGLETON_FOR_HEADER(CommonAlertVC);



@end

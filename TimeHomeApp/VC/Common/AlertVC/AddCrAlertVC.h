//
//  AddCrAlertVC.h
//  TimeHomeApp
//
//  Created by us on 16/2/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  添加车牌对话框
 *

 */
#import <UIKit/UIKit.h>

//添加车牌事件类型
typedef NS_ENUM(NSInteger,AddCarEventCodeType)
{
    ///确认
    ADDCAR_OK=100,
    ///取消
    ADDCAR_CANCEL,
    ///第一个下拉选择
    ADDCAR_FIRST,
    ///第二个下拉选择
    ADDCAR_SECOND
};


@interface AddCrAlertVC : BaseViewController

/**
 *  车牌第一位
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_CarNumFirstChar;
/**
 *  车牌第二位
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_CarNumSecondChar;
/**
 *  后五位
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_CarNumText;
/**
 *  车主姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_CarOwnerName;


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
 *  @param parent <#parent description#>
 */
-(void)ShowAlert:(UIViewController *)parent carNum:(NSString *)carnum remarks:(NSString *)remarks  eventCallBack:(ViewsEventBlock)eventCallBack;

/**
 *  获取实例
 *
 *  @return return value description
 */
+(AddCrAlertVC *)getInstance;
/**
 *  单例方法
 */
SYNTHESIZE_SINGLETON_FOR_HEADER(AddCrAlertVC);


@end

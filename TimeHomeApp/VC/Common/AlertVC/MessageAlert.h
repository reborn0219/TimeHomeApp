//
//  MessageAlert.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    
    Cancel_Type,
    Ok_Type
    
}BlockEnumType;

@interface MessageAlert : UIViewController

+(instancetype)shareMessageAlert;
@property (nonatomic,copy)ViewsEventBlock block;
-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andCancelBtnTitle:(NSString *)cancelBtnTitle andOtherBtnTitle:(NSString *)otherBtnTitle;
/** 富文本提示 */
- (void)newShowInVC:(UIViewController *)VC withTitle:(NSMutableAttributedString *)title andCancelBtnTitle:(NSString *)cancelBtnTitle andOtherBtnTitle:(NSString *)otherBtnTitle;
-(void)dismiss;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *megLb;
/**
 *  使用attributeString时设置为YES,使用msg时不用设置
 */
@property (nonatomic, assign) BOOL isNull;

@property (nonatomic, assign) BOOL closeBtnIsShow;

@property(assign,nonatomic) BOOL isHiddLeftBtn;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

/**
 *  获取实例
 *
 *  @return return value description
 */
+(MessageAlert *)getInstance;

@end

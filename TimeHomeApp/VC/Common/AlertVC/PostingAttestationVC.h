//
//  PostingAttestationVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    
    Cancel_Type,
    Ok_Type
    
}BlockEnumType;

@interface PostingAttestationVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic,copy)ViewsEventBlock block;

+(PostingAttestationVC *)getInstance;

+(instancetype)sharePostingAttestationVC;

//-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andButtonTitle:(NSString *)title2 andTopViewColor:(UIColor *)topViewColor andBlcok:(ViewsEventBlock)blcok;
-(void)dismiss;
-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andButtonTitle:(NSString *)title2 andTopViewColor:(UIColor *)topViewColor;
-(void)showInVC:(UIViewController *)VC;
@end

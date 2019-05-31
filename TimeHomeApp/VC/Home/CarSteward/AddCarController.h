//
//  AddCarController.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 * 添加车辆
 **/

#import "BaseViewController.h"
#import "LS_CarInfoModel.h"

typedef NS_ENUM(int,fromWhere){
    
    add,
    Modify
    
};
@interface AddCarController : THBaseViewController
@property (nonatomic)fromWhere from;
@property (weak, nonatomic) IBOutlet UIView *deviceBackV;
@property (weak, nonatomic) IBOutlet UIButton *scanningBtn;
@property (weak, nonatomic) IBOutlet UITextField *Car_No_TF;
//车牌
@property (weak, nonatomic) IBOutlet UITextField *carNumber;

//车辆品牌
@property (weak, nonatomic) IBOutlet UITextField *carBrand;

//车辆型号
@property (weak, nonatomic) IBOutlet UITextField *carModel;

//车款
@property (weak, nonatomic) IBOutlet UITextField *carStyle;
//确认按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong)NSMutableArray *arr;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *regionButton;
@property (weak, nonatomic) IBOutlet UIButton *regionTriangleButton;


@property (weak, nonatomic) IBOutlet UIButton *carFirstLetter;
@property (weak, nonatomic) IBOutlet UIButton *carFirstTriangleButton;


@property (nonatomic,assign)float tempNumber;
@property (nonatomic,strong)UIButton *button;

@property (weak, nonatomic) IBOutlet UIView *BGView;

@property (nonatomic , strong)UIView *gesturesView;

@property (weak, nonatomic) IBOutlet UIButton *modelButton;

@property (weak, nonatomic) IBOutlet UIButton *styleButton;

@property (nonatomic,copy)NSString *brandID; //车系ID
@property (nonatomic,copy)NSString *modelID; //车系ID
@property (nonatomic,copy)NSString *stytleID; //车系ID
@property (nonatomic, strong) NSString *engineno;//发动机

@property (nonatomic , strong) LS_CarInfoModel * carInfoModel;

- (IBAction)scanningAction:(id)sender;
@end

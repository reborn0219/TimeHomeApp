//
//  THMyRealNameViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyRealNameViewController.h"
#import "THDoorNumberView.h"
#import "THMyInfoPresenter.h"

@interface THMyRealNameViewController ()
{
    /**
     *  是否显示楼牌号
     */
    NSString *isshowname;
}
@property (nonatomic, strong) THDoorNumberView *doorNumberView;
/**
 *  登录用户信息
 */
@property (nonatomic, strong) UserData *userData;

@end

@implementation THMyRealNameViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:GeRenSheZhi];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":GeRenSheZhi}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"真实姓名";
    
    AppDelegate *appDelegate = GetAppDelegates;
    _userData = appDelegate.userData;
    isshowname = _userData.isshowname;
    
    [self createRightBarBtn];
    
    [self createDoorNumberView];
    
}
- (void)createDoorNumberView {
    
    _doorNumberView = [[THDoorNumberView alloc]initWithFrame:CGRectMake(7, 10, SCREEN_WIDTH-14.f, WidthSpace(338))];
    _doorNumberView.backgroundColor = [UIColor whiteColor];
    _doorNumberView.titleLabel.text = @"输入您的真实姓名";
    _doorNumberView.doorNumTF.placeholder = @"";
//    _doorNumberView.doorNumTF.delegate = self;
    if (![XYString isBlankString:_userData.name]) {
        _doorNumberView.doorNumTF.text = _userData.name;
    }else {
        _doorNumberView.doorNumTF.placeholder = @"输入您的真实姓名";
    }
    BOOL isShow = isshowname.intValue == 1 ? YES :NO;
    [_doorNumberView.switchButton setOn:isShow];
    [self.view addSubview:_doorNumberView];
    _doorNumberView.switchButtonCallBack = ^(BOOL isOpen) {
        
        if (!isOpen) {
            //关闭
            isshowname = @"0";
        }
        if (isOpen) {
            //打开
            isshowname = @"1";
        }
        
    };
    [_doorNumberView.doorNumTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void) textFieldDidChange:(CustomTextFIeld *) TextField{
    
    if (TextField == _doorNumberView.doorNumTF) {
        UITextRange * selectedRange = TextField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(TextField.text.length >= 4)
            {
                TextField.text=[TextField.text substringToIndex:4];
            }
        }
    }
    
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//{
//    //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
//    if ([string isEqualToString:@"\n"])  //按会车可以改变
//    {
//        return YES;
//    }
//    
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//    
//    if (_doorNumberView.doorNumTF == textField)  //判断是否时我们想要限定的那个输入框
//    {
//        if ([toBeString length] > 4) { //如果输入框内容大于10则弹出警告
//            textField.text = [toBeString substringToIndex:4];
//            return NO;
//        }
//    }
//    return YES;
//}

- (void)createRightBarBtn {
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completionClick)];
    [rightBtn setTintColor:kNewRedColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
- (void)completionClick {
    
    @WeakObj(self);

    [_doorNumberView.doorNumTF resignFirstResponder];
    
    if ([XYString isBlankString:_doorNumberView.doorNumTF.text]) {
        [self showToastMsg:@"真实姓名不能为空" Duration:2.0];
        return;
    }
    
    
    NSString *nameString = [_doorNumberView.doorNumTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (nameString.length < 2 || nameString.length > 4) {
        [self showToastMsg:@"真实姓名应为2-4字" Duration:2.0];
        return;
    }
    
//    NSString *name = @"";
//    if (![XYString isBlankString:_doorNumberView.doorNumTF.text]) {
//        name = _doorNumberView.doorNumTF.text;
//    }else if (![XYString isBlankString:_doorNumberView.doorNumTF.placeholder]) {
//        name = _doorNumberView.doorNumTF.placeholder;
//    }else {
//        return;
//    }
    
    //保存真实姓名请求
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
    [THMyInfoPresenter perfectMyUserInfoDict:@{@"name":_doorNumberView.doorNumTF.text,@"isshowname":isshowname} UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        [GCDQueue executeInGlobalQueue:^{
            [GCDQueue executeInMainQueue:^{
                [indicator stopAnimating];
                
                if(resultCode == SucceedCode)
                {
                    
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                }
                
            }];
        }];

        
    }];
}

@end

//
//  ZSY_LoginHelp.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import "ZSY_LoginHelp.h"
#import "ZSY_ZSY_LoginHelpCell.h"
#import "MySettingAndOtherLogin.h"
#import "RegularUtils.h"
#define MAX_LIMIT_NUMS     100
@interface ZSY_LoginHelp ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextViewDelegate>
{
    NSString *phonetypeStr;
    NSString *problemStr;
}

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *selectArray;
/**
 1001 无法登陆 
 1002 收不到短信 
 1003 遇到其他问题
 9999用户反馈
 */
@property (nonatomic,copy)NSString *typeStr;
/**
 问题描述
 */
@property (nonatomic,copy)NSString *contentStr;
/**
 图片id 传空
 */
@property (nonatomic,copy)NSString *picid;

@end

@implementation ZSY_LoginHelp

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助与反馈";
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationController.navigationBarHidden = NO;
    [self createUI];
    [self createDataSource];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:DengLu];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":DengLu}];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)createUI {
    _scrollView.backgroundColor = BLACKGROUND_COLOR;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_ZSY_LoginHelpCell" bundle:nil] forCellReuseIdentifier:@"LoginHelpCell"];
    _tableView.scrollEnabled =NO;
    
    _textView.layer.borderWidth = 1.0;
    _textView.layer.borderColor = TEXT_COLOR.CGColor;
    _textView.delegate = self;
    _placeHolderTextView.layer.borderWidth = 1.0;
    _placeHolderTextView.layer.borderColor = TEXT_COLOR.CGColor;
    _placeHolderTextView.delegate = self;
    
    _tfBgView.layer.borderWidth = 1.0f;
    _tfBgView.layer.borderColor = TEXT_COLOR.CGColor;
    _tf.keyboardType = UIKeyboardTypePhonePad;
    _phoneType.enabled = NO;
    AppDelegate *apple = GetAppDelegates;
    _phoneType.text = [NSString stringWithFormat:@"您当前的机型为:%@",[apple iphoneType]];
    
}
#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
//    _showLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
    
    
    
    if (textView.markedTextRange == nil) {
        _showLabel.text = [NSString stringWithFormat:@"%ld",textView.text.length];
        _contentStr = textView.text;
    }else {
        _showLabel.text = @"0";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    switch (textView.tag) {
        case 11:
            
            break;
        case 12:
            if (![text isEqualToString:@""]) {
                
                _placeHolderTextView.hidden = YES;
                _textView.backgroundColor = [UIColor whiteColor];
            }
            
            if (range.location == 0 && range.length == 1 && textView.text.length == 1) {
                //[text isEqualToString:@""] 表示输入的是退格键range.location == 0 && range.length == 1 表示输入的是第一个字符
                _placeHolderTextView.hidden = NO;
                _textView.backgroundColor = [UIColor clearColor];
            }

            break;
            
        default:
            break;
    }
    
    if (range.location > 100 || textView.text.length > 100){
        return NO;
    }
    NSLog(@"%ld",text.length);
    return YES;
}

#pragma mark -- createDataSource
- (void)createDataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    [_dataSource addObjectsFromArray:@[@"我无法登录",@"我收不到短信验证码",@"我遇到了其他问题"]];
    
    _selectArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataSource.count; i++) {
        [_selectArray addObject:@"0"];
    }
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource   列表代理
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZSY_ZSY_LoginHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginHelpCell"];
    cell.titleLabel.text = _dataSource[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([_selectArray[indexPath.row] isEqualToString:@"0"]) {
        cell.isSelected = NO;
    }else {
        
        cell.isSelected = YES;
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    problemStr = _dataSource[indexPath.row];
    [_selectArray removeAllObjects];
    for (int i = 0; i < 20; i++) {
        [_selectArray addObject:@"0"];
    }
    [_selectArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [_tableView reloadData];
}




///点击空白收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesbegan:withevent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    
}
#pragma mark -- 按钮点击事件
- (IBAction)submitClcik:(id)sender {
    if ([XYString isBlankString:problemStr]) {
        [self showToastMsg:@"请选择您在登录中遇到的问题" Duration:3.0];
        return;
    }
    
    if ([XYString isBlankString:_tf.text])  {
        [self showToastMsg:@"请填写接收问题回复的手机号/QQ" Duration:3.0];
        return;
    }
    if(![RegularUtils iszipCode:_tf.text] && ![RegularUtils isQQ:_tf.text])
    {
        [self showToastMsg:@"手机号或QQ号不正确,请重新输入" Duration:3.0];
        return;
    }
    
    
    if ([problemStr isEqualToString:@"我无法登录"]) {
        _typeStr = @"1001";
    }else if ([problemStr isEqualToString:@"我收不到短信验证码"]) {
        _typeStr = @"1002";
    }else if ([problemStr isEqualToString:@"我遇到了其他问题"]) {
        _typeStr = @"1003";
    }
    NSString *content = [XYString IsNotNull:_contentStr];
    
    /*
     *title随便传一个参数进去
     *
     */
    AppDelegate *apple = GetAppDelegates;
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [MySettingAndOtherLogin addMyFeedBackWithType:_typeStr andContent:content andPicID:@"" andLinkinfo:_tf.text andPhonemodel:[apple iphoneType] andTitle:@"title" andUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                //成功
                [selfWeak showToastMsg:@"提交成功" Duration:3.0];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                //失败
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
        });
    }];
}



@end

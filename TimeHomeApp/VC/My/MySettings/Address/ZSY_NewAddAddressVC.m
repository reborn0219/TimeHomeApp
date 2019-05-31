//
//  ZSY_NewAddAddressVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/9/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_NewAddAddressVC.h"
#import "ZSY_NewAddressCell1.h"
#import "ZSY_NewAddressCell2.h"
#import "ZSY_NewAddressCell3.h"
#import "ZSY_NewAddressCell4.h"
#import "ZSY_AddNewAddressVC.h"
#import "RegularUtils.h"
#import "MySettingAndOtherLogin.h"
@interface ZSY_NewAddAddressVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *dataSource2;

/** 接口参数 */
@property (nonatomic,copy)NSString *nameStr; //联系人姓名
@property (nonatomic,copy)NSString *phoneNumberStr; //手机号
@property (nonatomic,copy)NSString *zipStr; //邮政编码
@property (nonatomic,copy)NSString *regionStr; //所在地区
@property (nonatomic,copy)NSString *detailedAddressStr; //详细地址信息
@property (nonatomic,copy)NSString *isDefault; //设为默认地址
@end

@implementation ZSY_NewAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationItem.title = @"新增地址";
    [self createTableView];
    [self createDataSource];
    _okButton.backgroundColor = kNewRedColor;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isDefault = @"0";
}


#pragma mark -- createTableView & dataSource
- (void)createTableView {
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_NewAddressCell1" bundle:nil] forCellReuseIdentifier:@"ZSY_NewAddressCell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_NewAddressCell2" bundle:nil] forCellReuseIdentifier:@"ZSY_NewAddressCell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_NewAddressCell3" bundle:nil] forCellReuseIdentifier:@"ZSY_NewAddressCell3"];
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_NewAddressCell4" bundle:nil] forCellReuseIdentifier:@"ZSY_NewAddressCell4"];
}
- (void)createDataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    [_dataSource addObjectsFromArray:@[@"联系人姓名",@"手机号",@"邮政编码",@"所在地区",@""]];
    if (!_dataSource2) {
        _dataSource2 = [[NSMutableArray alloc] init];
        [_dataSource2 addObject:@"设为默认地址"];
    }

}
#pragma mark -- UITableViewDelegate,UITableViewDataSource   列表代理
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _dataSource.count;
    }else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 4) {
            return 60;
        }
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        /**
         地区选择
         */
        if (indexPath.row == 3) {
            ZSY_NewAddressCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"ZSY_NewAddressCell2"];
            [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell2.textField.tag = 14;
            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            @WeakObj(cell2)
            cell2.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index){
                
                ZSY_AddNewAddressVC *addNew = [ZSY_AddNewAddressVC shareaddNewAddressVC];
                [addNew show:self];
                addNew.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
                    NSArray *array = [data componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组

                    NSString *str1 = array[0];
                    NSString *str2 = array[1];
                    NSString *str3 = array[2];
                    if ([str1 isEqualToString:@"(null)"]) {
                        str1 = @"";
                    }
                    if ([str2 isEqualToString:@"(null)"]) {
                        str2 = @"";
                    }
                    if ([str3 isEqualToString:@"(null)"]) {
                        str3 = @"";
                    }
                    NSString *showStr = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
                    cell2Weak.textField.text = showStr;
                    if (cell2Weak.textField.text.length > 0) {
                        cell2Weak.showLabel.hidden = YES;
                        cell2Weak.right.constant = -5;
                        _regionStr = cell2Weak.textField.text;
                    }
                };
            };
            cell2.titleLabel.text = _dataSource[indexPath.row];
                        return cell2;
            
        }else if (indexPath.row == 4) {
            
            /**
             输入详细地址
             */
            ZSY_NewAddressCell4 *cell4 = [tableView dequeueReusableCellWithIdentifier:@"ZSY_NewAddressCell4"];
            [cell4 setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell4.textField.delegate = self;
            cell4.textField.tag = 15;
            [cell4.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            return cell4;
            
        }else {
            /**
             上边的三个row
             */
            ZSY_NewAddressCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSY_NewAddressCell1"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.titleLabel.text = _dataSource[indexPath.row];
            cell.textField.tag = 11 + indexPath.row;
            cell.textField.delegate = self;
            [cell.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            if (indexPath.row == 1 || indexPath.row == 2) {
                cell.textField.keyboardType = UIKeyboardTypePhonePad;
            }
            return cell;
        }
        
    }else {
        /**
         设为默认地址
         */
        ZSY_NewAddressCell3 *cell3 = [tableView dequeueReusableCellWithIdentifier:@"ZSY_NewAddressCell3"];
        [cell3.clickButton addTarget:self action:@selector(defaultButton:) forControlEvents:UIControlEventTouchUpInside];
        cell3.myImageView.tag = 1;
        [cell3 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell3;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark --- 输入框事件
- (void)textFieldChanged:(UITextField *)textField {
    if (textField.tag == 11) {
        _nameStr = textField.text;
    }else if (textField.tag == 12) {
        _phoneNumberStr = textField.text;
    }else if (textField.tag == 13) {
        _zipStr = textField.text;
    }else if (textField.tag == 15) {
        _detailedAddressStr = textField.text;
        NSLog(@"textfield text %@",textField.text);
    }
}

#pragma mark --- 按钮点击事件
///选择是否默认按钮点击事件
- (void)defaultButton:(UIButton *)button {
    button.selected = !button.selected;
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1];
    if (button.selected == YES) {
        imageView.image = [UIImage imageNamed:@"选中图标"];
        _isDefault = @"1";
    }else {
        imageView.image = [UIImage imageNamed:@"未选中图标"];
        _isDefault = @"0";
    }
    button.selected = button.selected;
}

///提交按钮
- (IBAction)confirmButton:(id)sender {
    for (int i = 11; i <= 15; i++) {
        UITextField *tf = (UITextField *)[self.view viewWithTag:i];
        
        switch (tf.tag) {
            case 11:
                if ([XYString isBlankString:tf.text]) {
                    [self showToastMsg:@"姓名不能为空,请重新输入" Duration:3.0];
                    return;
                }
                break;
            case 12:
                if ([XYString isBlankString:tf.text]) {
                    [self showToastMsg:@"手机号不能为空,请重新输入" Duration:3.0];
                    return;
                }
                if(![RegularUtils isPhoneNum:tf.text])//验证手机号正确
                {
                    [self showToastMsg:@"手机号不正确,请重新输入" Duration:3.0];
                    return;
                }
                break;
            case 13:
                if ([XYString isBlankString:tf.text]) {
                    [self showToastMsg:@"邮政编码不能为空,请重新输入" Duration:3.0];
                    return;
                }
                if(![RegularUtils iszipCode:tf.text])
                {
                    [self showToastMsg:@"邮政编码不正确,请重新输入" Duration:3.0];
                    return;
                }

                break;
            case 14:
                if ([XYString isBlankString:tf.text]) {
                    [self showToastMsg:@"所在地区不能为空,请重新输入" Duration:3.0];
                    return;
                }
                break;
            case 15:
                if ([XYString isBlankString:tf.text]) {
                    [self showToastMsg:@"详细地址不能为空,请重新输入" Duration:3.0];
                    return;
                }
                break;
                
            default:
                break;
        }
    }
    
    
    
    ///ID 和省市区的ID
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [MySettingAndOtherLogin saveMyAddressWithID:@"null" AndProvinceid:@"null" AndCityid:@"null" AndAreaid:@"null" AndAddress:_detailedAddressStr AndLinkMan:_nameStr AndLinkPhone:_phoneNumberStr AndIsDefault:_isDefault AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                ///新增时会返回一个ID
                NSDictionary *dict = (NSDictionary *)data;
                NSLog(@"-----%@",[dict objectForKey:@"id"]);
                
            }else {
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
        });
    }];
}

@end

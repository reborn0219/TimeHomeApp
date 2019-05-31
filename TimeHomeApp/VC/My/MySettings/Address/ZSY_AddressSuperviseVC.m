//
//  ZSY_AddressSuperviseVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/9/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_AddressSuperviseVC.h"
#import "ZSY_NewAddAddressVC.h"
#import "ZSY_AddressSuperviseCell.h"
#import "UIButtonImageWithLable.h"
#import "MySettingAndOtherLogin.h"
#import "GetMyAddress.h"
#import "RegularUtils.h"
@interface ZSY_AddressSuperviseVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
/**
 列表以及数据源
 */
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
/**
 当前的row
 */
@property (nonatomic,assign)NSInteger currentIndexPath;
/**
 当前index
 */
@property (nonatomic,assign)NSIndexPath *theIndex;

@end

@implementation ZSY_AddressSuperviseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationItem.title = @"新增地址";
    [self createTableView];
    [self createDataSource];
}

#pragma mark -- createTableView And dataSource
- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, (SCREEN_HEIGHT-64)/6 * 5) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_AddressSuperviseCell" bundle:nil] forCellReuseIdentifier:@"SuperviseCell"];
    
    /**
     新增收货地址按钮
     */
    UIButton *addAddressButton = [[UIButton alloc] init];
    [self.view addSubview:addAddressButton];
    addAddressButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(_tableView,8).heightIs(35).widthIs(35);
    [addAddressButton setImage:[UIImage imageNamed:@"邻趣-发布-添加标签图标"] forState:UIControlStateNormal];
    [addAddressButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [addAddressButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *textButton = [[UIButton alloc] init];
    [self.view addSubview:textButton];
    textButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(addAddressButton,0).heightIs(21).widthIs(90);
    [textButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [textButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    textButton.titleLabel.font = DEFAULT_FONT(14);
    [textButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createDataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [MySettingAndOtherLogin getMyAddressWithPagesize:@"" AndPage:@"" AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                NSDictionary *dict = (NSDictionary *)data;
                [_dataSource removeAllObjects];
                NSArray *array = [GetMyAddress mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"list"]];
                [_dataSource addObjectsFromArray:array];
                [selfWeak.tableView reloadData];

            }else {
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
            
            if (_dataSource.count == 0) {
                
                [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"暂无数据" eventCallBack:nil];
                selfWeak.tableView.hidden = YES;
                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                
            }else {
                selfWeak.tableView.hidden = NO;
                
            }

            
        });
    }];
    
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 190;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GetMyAddress *model = _dataSource[indexPath.row];
    /**
     ID;          收货记录id
     provinceid;  省id
     provincename;省名称
     cityid;      市id
     cityname;    市区名称
     areaid;      区域id
     areaname;    区域名称
     address;     详细地址
     linkman;     联系人
     linkphone;   联系电话
     isdefault;   是否默认 0 否1 是
     */
    ZSY_AddressSuperviseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuperviseCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addressTextView.delegate = self;
    cell.nameTF.delegate = self;
    cell.phoneNumberTF.delegate = self;

    cell.nameTF.text = model.linkman;
    cell.addressTextView.text = model.address;
    cell.phoneNumberTF.text = model.linkphone;
    if ([model.isdefault isEqualToString:@"1"]) {
        //默认地址
        cell.isDefault = YES;
    }else if([model.isdefault isEqualToString:@"0"]){
        cell.isDefault = NO;
    }

    if (cell.addressTextView.text.length <= 16) {
        cell.addressImagetop.constant = 22;
        cell.addressTop.constant = 11;
    }
    /**
     cell上的按钮点击事件
     */
    @WeakObj(cell)
    cell.block2 = ^(id _Nullable data,UIView *_Nullable view,NSInteger index){
        if (index == 1) {
            //编辑
            cellWeak.addressTextView.editable = YES;
            cellWeak.nameTF.enabled = YES;
            cellWeak.phoneNumberTF.enabled = YES;
            _currentIndexPath = indexPath.row;
            _theIndex = indexPath;
            [cellWeak.nameTF becomeFirstResponder];
        }else if (index == 2) {
            /**
             删除
             */
            [_dataSource removeObjectAtIndex:[indexPath row]];  //删除_data数组里的数据
            [_tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
            [_tableView reloadData];
            
            [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
            [MySettingAndOtherLogin deleteAddressWithReceiptid:@"地址的ID" andUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                @WeakObj(self)
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                    
                    if (resultCode == SucceedCode) {
                        
                        
                    }else {
                        [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                    }
                });

            }];
            
        }else if (index == 3) {
            //设为默认

            [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
            [MySettingAndOtherLogin saveMyAddressWithID:model.ID AndProvinceid:model.provinceid AndCityid:model.cityid AndAreaid:model.areaid AndAddress:cellWeak.addressTextView.text AndLinkMan:cellWeak.nameTF.text AndLinkPhone:cellWeak.phoneNumberTF.text AndIsDefault:model.isdefault AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                @WeakObj(self)
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                    
                    if (resultCode == SucceedCode) {
                        
                        
                    }else {
                        [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                    }
                });
            }];
            
            //默认地址移动到第一行
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:toIndexPath.row];
            [_tableView moveRowAtIndexPath:indexPath toIndexPath:toIndexPath];
            [_tableView reloadData];
            NSLog(@"设为默认地址");
            
        }
        
    };
        return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return NO;
    }
    return YES; //可以移动
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -- textView代理方法
- (void)textViewDidEndEditing:(UITextView *)textView {
    UITextField *nameTF = (UITextField *)[self.view viewWithTag:5];
    UITextField *numberTF= (UITextField *)[self.view viewWithTag:6];
    textView.editable = NO;
    nameTF.enabled = NO;
    numberTF.enabled = NO;
    
    GetMyAddress *model = _dataSource[_currentIndexPath];
    ZSY_AddressSuperviseCell *myCell = [_tableView cellForRowAtIndexPath:_theIndex];
    //完成编辑时提交
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [MySettingAndOtherLogin saveMyAddressWithID:model.ID AndProvinceid:model.provinceid AndCityid:model.cityid AndAreaid:model.areaid AndAddress:myCell.addressTextView.text AndLinkMan:myCell.nameTF.text AndLinkPhone:myCell.phoneNumberTF.text AndIsDefault:model.isdefault AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                
            }else {
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
        });
    }];

}

#pragma mark -- textField代理
-(void)textFieldDidEndEditing:(UITextField *)textField {
    UITextView *textView = (UITextView *)[self.view viewWithTag:101];
    UITextField *nameTF = (UITextField *)[self.view viewWithTag:5];
    UITextField *numberTF= (UITextField *)[self.view viewWithTag:6];
    if (textField.tag == 6) {
        if(![RegularUtils isPhoneNum:textField.text])//验证手机号正确
        {
            [self showToastMsg:@"手机号不正确,请重新输入" Duration:5];
            return;
        }
        textField.enabled = NO;
        nameTF.enabled = NO;
        textView.editable = NO;
    }else {
        textField.enabled = NO;
        numberTF.enabled = NO;
        textView.editable = NO;
    }
    
}
#pragma mark --- 按钮点击事件
///添加新地址
- (void)addAddress:(UIButton *)button {
    ZSY_NewAddAddressVC *newAddress = [[ZSY_NewAddAddressVC alloc] init];
    [self.navigationController pushViewController:newAddress animated:YES];
}
@end

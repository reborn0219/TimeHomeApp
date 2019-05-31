//
//  THMyCarAuthorityViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyCarAuthorityViewController.h"
#import "THAuthorityTitleTVC.h"
#import "THInPutTVC.h"
#import "THMyCarRentTVCStyle2.h"
/**
 *  网络请求
 */
#import "ParkingAuthorizePresenter.h"
#import "AppSystemSetPresenters.h"

#import "MMDateView.h"
#import "MMPopupWindow.h"
/**
 *  手机号判断
 */
#import "RegularUtils.h"
/**
 *  关连用户通讯录
 */
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#import "IntelligentGarageVC.h"


@interface THMyCarAuthorityViewController () <UITableViewDelegate, UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate>
{
    NSArray *leftTitles;//左边标题
    NSString *beginDateString;//开始日期
    NSString *endDateString;//结束日期
    /**
     *  手机号
     */
    NSString *phoneNum;
    /**
     *  联系人名字
     */
    NSString *peopleName;
    
    CNContactPickerViewController *contactVC;
    
    //通讯录权限
    BOOL accessGranted;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LXModel *model;

@end

@implementation THMyCarAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //----------提示框的默认按钮设置---------------------
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    self.navigationItem.title = @"车位出租";
    
    [self setUp];

    [self createTableView];
    
    [self getAppsystemTime];
    
    //通讯录权限
    [self accessTheAddress];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
/**
 *  获取当前时间
 */
- (void)getAppsystemTime {
    
//    @WeakObj(self);
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [AppSystemSetPresenters getSystemTimeUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                if (![XYString isBlankString:data]) {
                    beginDateString = [(NSString *)data substringToIndex:10];
                }else {
                    beginDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
                }
            }
            else
            {
                beginDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
//                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
            [_tableView reloadData];
            
        });
        
    }];
    
}
/**
 *  数据初始化
 */
- (void)setUp {
    
//    beginDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
    endDateString = @"";
    phoneNum = @"";
    peopleName = @"";
    leftTitles = @[@"手  机  号",@"姓       名",@"开始日期",@"结束日期"];
    
    _model = [[LXModel alloc]init];
    _model.content = @"在租期内您对该车位的管理权限将移交给被授权人";
}

- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THAuthorityTitleTVC class] forCellReuseIdentifier:NSStringFromClass([THAuthorityTitleTVC class])];
    [_tableView registerClass:[THInPutTVC class] forCellReuseIdentifier:NSStringFromClass([THInPutTVC class])];
    [_tableView registerClass:[THMyCarRentTVCStyle2 class] forCellReuseIdentifier:NSStringFromClass([THMyCarRentTVCStyle2 class])];

}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 60;
    }
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    
    if (section == 1) {
        UIButton *authorityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        authorityButton.backgroundColor = kNewRedColor;
        [authorityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [authorityButton setTitle:@"出  租" forState:UIControlStateNormal];
        authorityButton.titleLabel.font = DEFAULT_BOLDFONT(16);
        [authorityButton addTarget:self action:@selector(authorityClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:authorityButton];
        [authorityButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(WidthSpace(68));
            make.right.equalTo(view).offset(-WidthSpace(68));
            make.top.equalTo(view).offset(18);
            make.height.equalTo(@(WidthSpace(64)));
        }];
    }
    
    
    return view;
}

/**
 比较结束日期是否大于开始日期
 
 @param startTime 开始时间 yyyy-mm-dd
 @param endTime 结束时间 yyyy-mm-dd
 @return 是否合法
 */
- (BOOL)timeCompareRightfulWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDate * startDate = [NSDate dateWithString:startTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * endDate = [NSDate dateWithString:[endTime stringByAppendingString:@" 00:00:00"] format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timerInterval = [endDate timeIntervalSinceDate:startDate];
    if (timerInterval >= 0) {
        return YES;
    }
    return NO;
}

/**
 *  出租按钮点击
 */
- (void)authorityClick {
    
    @WeakObj(self);
    
    NSLog(@"phoneNum===%@",phoneNum);
    NSLog(@"peopleName===%@",peopleName);
    
    //手机号
    THInPutTVC *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell1.phoneTF resignFirstResponder];
    //姓名
    THInPutTVC *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    [cell2.phoneTF resignFirstResponder];
    
    
    // 如果服务到期时间不为空 并且 出租结束日期大于服务到期时间则 return;
    if (self.owner.expiretime && self.owner.expiretime.length > 5) {
        BOOL rightTime = [self timeCompareRightfulWithStartTime:self.owner.expiretime endTime:endDateString];
        if (rightTime) {
            [self showToastMsg:@"出租日期不能超出服务结束时间" Duration:3];
            return;
        }
    }
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [ParkingAuthorizePresenter saveParkingPowerForType:@"1" parkingareaid:_owner.theID phone:phoneNum name:peopleName rentbegindate:beginDateString rentenddate:endDateString upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                if (selfWeak.callBack) {
                    selfWeak.callBack();
                }
                if(self.isFromParking)
                {
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                       
                        if ([controller isKindOfClass:[IntelligentGarageVC class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }

                }
                else
                {
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                }
                
            }
            else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
        });
        
    }];


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return WidthSpace(80);
        }else {
            return [_tableView cellHeightForIndexPath:indexPath model:_model keyPath:@"model" cellClass:[THMyCarRentTVCStyle2 class] contentViewWidth:[self cellContentViewWith]];
        }
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @WeakObj(self);
    THAuthorityTitleTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THAuthorityTitleTVC class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.houseNameLabel.text = [NSString stringWithFormat:@"%@ %@",_owner.communityname,_owner.name];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        THMyCarRentTVCStyle2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THMyCarRentTVCStyle2 class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = _model;
        return cell;
    }
    if (indexPath.section == 1) {
        THInPutTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THInPutTVC class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightViewLength = RightViewLengthDefault;
        if (indexPath.row == 0) {
            cell.phoneTF.placeholder = @"请输入被授权人的手机号";
            cell.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
            if (![XYString isBlankString:phoneNum]) {
                cell.phoneTF.text = phoneNum;
            }
            [cell.phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.rightButton.hidden = NO;
            cell.peopleInfosCallBack = ^(){
                
                //通讯录匹配
                [selfWeak setUpAddressInfo];
                
            };
            cell.textFieldCallBack = ^(NSString *string){
                
                //手机号
                phoneNum = string;
                if (![RegularUtils isPhoneNum:phoneNum]) {
                    [selfWeak showToastMsg:@"手机号码格式输入不正确" Duration:2.0];
                }
                
            };
        }else {
            cell.rightButton.hidden = YES;
        }
        
        cell.leftTitleLabel.text = leftTitles[indexPath.row];
        
        if (indexPath.row == 0 || indexPath.row == 1) {
            cell.viewType = ViewTypeTextField;
            if (indexPath.row == 1) {
                cell.phoneTF.placeholder = @"请输入被授权人的姓名";
                [cell.phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                if (![XYString isBlankString:peopleName]) {
                    cell.phoneTF.text = peopleName;
                }
                
                cell.textFieldCallBack = ^(NSString *string){
                    
                    //姓名
                    peopleName = string;
                    
                };
                
            }
        }else {
            cell.viewType = ViewTypeButton;
            if (indexPath.row == 2) {
                cell.buttonTitleLabel.text = beginDateString;
                cell.dateSelectButton.selected = YES;
                
            }else {
                if (![XYString isBlankString:endDateString]) {
                    cell.buttonTitleLabel.text = endDateString;
                }else {
                    cell.buttonTitleLabel.text = @"请选择出租结束日期";
                }
                cell.dateSelectButton.selected = NO;
                
            }
        }
        __weak THInPutTVC *inputCell = cell;
        cell.dateButtonClickCallBack = ^(BOOL buttonSelected) {
            
            //手机号
            THInPutTVC *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            [cell1.phoneTF resignFirstResponder];
            //姓名
            THInPutTVC *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            [cell2.phoneTF resignFirstResponder];
            
            if (!buttonSelected) {
                
                MMDateView *dateView = [[MMDateView alloc]init];
                dateView.titleLabel.text = @"结束日期";

                NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",beginDateString] withFormat:@"yyyy-MM-dd"];
                NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
                dateView.datePicker.minimumDate = nextDate;
                [dateView show];
                dateView.confirm = ^(NSString *data) {
                    
                    NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",data] withFormat:@"yyyy/MM/dd"];
                    NSString *str = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];

                    endDateString = str;
                    inputCell.buttonTitleLabel.text = str;
                    
                };
                    
            }
            
        };
        
        return cell;
    }
    
    
    return cell;
}
- (void) textFieldDidChange:(CustomTextFIeld *) TextField{
    
    //手机号
    THInPutTVC *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //姓名
    THInPutTVC *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    if (TextField == cell1.phoneTF) {
        UITextRange * selectedRange = TextField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            phoneNum = TextField.text;
            if(TextField.text.length >= 11)
            {
                TextField.text=[TextField.text substringToIndex:11];
                phoneNum = TextField.text;
            }
        }
    }
    if (TextField == cell2.phoneTF) {
        UITextRange * selectedRange = TextField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            peopleName = TextField.text;
            if(TextField.text.length >= 4)
            {
                TextField.text=[TextField.text substringToIndex:4];
                peopleName = TextField.text;
            }
        }
    }

    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 15;
    if ((indexPath.section == 0 && indexPath.row == 1) || indexPath.section == 1) {
        width = SCREEN_WIDTH/2-7;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, width, 0, width)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, width, 0, width)];
    }
    
    
}

/**
 *  初始化系统通讯录
 */
- (void)setUpAddressInfo {
    
    if (accessGranted) {
        if (IOS9_OR_LATER) {
            
            contactVC = [[CNContactPickerViewController alloc] init];

            contactVC.delegate = self;
            
            [self presentViewController:contactVC animated:YES completion:nil];
            
        }else {
            
            ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
            nav.peoplePickerDelegate = self;
            if(IOS8_OR_LATER){
                nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            }
            nav.navigationBar.tintColor = [UIColor whiteColor];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }else {
        [self showToastMsg:@"您的通讯录没有开启授权" Duration:3.0];
    }
    
}
//通讯录授权
- (BOOL)accessTheAddress
{
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    accessGranted = NO;
    
    if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            accessGranted=granted;
            
            if (error){
                
                NSLog(@"Error: %@", (__bridge NSError *)error);
            }
            else if (!granted)
            {
                
            }
            else
            {
                accessGranted = YES;
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusAuthorized){
        accessGranted=YES;
    }
    else
    {
        NSLog(@"用户未授权提示");
        [self showToastMsg:@"您的通讯录没有开启授权" Duration:3.0];
    }
    return accessGranted;
}

#pragma mark - 选中一个联系人属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    NSLog(@"contactProperty:%@",contactProperty);

    
    CNContact *contact = contactProperty.contact;
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString *phoneNO = [NSString stringWithFormat:@"%@",phoneNumber.stringValue];
    
    for (CNLabeledValue *labeledValue in contact.phoneNumbers) {

        CNPhoneNumber *phoneNumber = labeledValue.value;

        NSLog(@"phoneNumber==%@",phoneNumber.stringValue);

    }
    
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([RegularUtils isPhoneNum:phoneNO]) {
        phoneNum = @"";
        peopleName = @"";
        
        phoneNum = [phoneNum stringByAppendingFormat:@"%@",phoneNO];
        if (![XYString isBlankString:contact.familyName]) {
            peopleName = [peopleName stringByAppendingFormat:@"%@",contact.familyName];
        }
        if (![XYString isBlankString:contact.givenName]) {
            peopleName = [peopleName stringByAppendingFormat:@"%@",contact.givenName];
        }
        
        if (peopleName.length > 4) {
            peopleName = [peopleName substringToIndex:4];
        }
        
        [self.tableView reloadData];
        
        return;
        
    }else {
        [self showToastMsg:@"请选择手机号" Duration:2.0];
    }

    
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate
//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  iOS8下
 *
 *  @param peoplePicker
 *  @param person
 *  @param property
 *  @param identifier
 */
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    //读取middlename
    NSString *middlename = (__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    
    
    if ([RegularUtils isPhoneNum:phoneNO]) {
        phoneNum = @"";
        peopleName = @"";
        
        phoneNum = [phoneNum stringByAppendingFormat:@"%@",phoneNO];
        if (![XYString isBlankString:firstName]) {
            peopleName = [peopleName stringByAppendingFormat:@"%@",firstName];
        }
        if (![XYString isBlankString:middlename]) {
            peopleName = [peopleName stringByAppendingFormat:@"%@",middlename];
        }
        if (![XYString isBlankString:lastName]) {
            peopleName = [peopleName stringByAppendingFormat:@"%@",lastName];
        }
        
        [_tableView reloadData];

        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return;
    }else {
        [self showToastMsg:@"请选择手机号" Duration:2.0];
    }
    
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

@end

//
//  L_AuthoryMyRentorViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_AuthoryMyRentorViewController.h"

#import "WebViewVC.h"

#import "L_DatePickerViewController.h"

/**
 *  关连用户通讯录
 */
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
/**
 *  判断手机号
 */
#import "RegularUtils.h"

#import "CommunityManagerPresenters.h"

#import "L_HouseDetailViewController1.h"

#import "AppSystemSetPresenters.h"

@interface L_AuthoryMyRentorViewController () <ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate, UINavigationControllerDelegate>
{
    /**
     *  手机号
     */
    NSString *phoneNum;
    /**
     *  联系人名字
     */
    NSString *peopleName;
    //通讯录权限
    BOOL accessGranted;
    
    NSString *beginDate;
    NSString *endDate;
    
    NSString *beginMinDate;
}
/**
 姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *name_TF;

/**
 电话
 */
@property (weak, nonatomic) IBOutlet UITextField *phone_TF;

/**
 通讯录
 */
@property (weak, nonatomic) IBOutlet UIButton *contact_Btn;

/**
 开始日期
 */
@property (weak, nonatomic) IBOutlet UILabel *startDate_Label;

/**
 结束日期
 */
@property (weak, nonatomic) IBOutlet UILabel *endDate_Label;

/**
 开始日期按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *startDate_Button;

/**
 结束日期按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *endDate_Button;

/**
 温馨提示
 */
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;

@end

@implementation L_AuthoryMyRentorViewController

#pragma mark - 获取当前时间

- (void)getAppsystemTime {

    THIndicatorVCStart
    [AppSystemSetPresenters getSystemTimeUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            THIndicatorVCStopAnimating
            
            if(resultCode == SucceedCode) {
                beginMinDate = [(NSString *)data substringToIndex:10];
                beginDate = [(NSString *)data substringToIndex:10];
                _startDate_Label.text = beginMinDate;
            }
            
        });
        
    }];
    
}

#pragma mark - 字数限制

- (IBAction)tfEditingValueChanged:(UITextField *)sender {
    
    if (sender == _name_TF) {
        UITextRange * selectedRange = _name_TF.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(_name_TF.text.length >= 4)
            {
                _name_TF.text = [_name_TF.text substringToIndex:4];
            }
        }
    }

    if (sender == _phone_TF) {
        UITextRange * selectedRange = _phone_TF.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(_phone_TF.text.length >= 11)
            {
                _phone_TF.text = [_phone_TF.text substringToIndex:11];
            }
        }
    }
    
}

#pragma mark - 通讯录点击

- (IBAction)addressInfoBtnDidClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [self setUpAddressInfo];
}

#pragma mark - 按钮点击

- (IBAction)allButtonsDidClick:(UIButton *)sender {
    
    [self.view endEditing:YES];

    //1.保存 2.开始日期 3.结束日期
    
    if (sender.tag == 1) {
        NSLog(@"保存");
        
        if ([XYString isBlankString:_name_TF.text]) {
            [self showToastMsg:@"您还没有填写被授权人姓名" Duration:3.0];
            return;
        }
        
        if ([XYString isBlankString:_phone_TF.text]) {
            [self showToastMsg:@"请输入被授权人的手机号码" Duration:3.0];
            return;
        }
        
        /**
         *  保存住宅授权信息
         */
        THIndicatorVCStart
        [CommunityManagerPresenters saveResidencePowerPowertype:@"1" residenceid:_theID phone:_phone_TF.text name:_name_TF.text rentbegindate:beginDate rentenddate:endDate UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                THIndicatorVCStopAnimating
                
                if(resultCode == SucceedCode) {
                    
                    [self showToastMsg:@"授权成功" Duration:2.0];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCertifyCommunityNeedRefresh object:nil];

                    if (_type == 1) {
                        
//                        L_HouseDetailViewController1 * houseDetailVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
//                        houseDetailVC.type = 4;
//                        if (self.callBack) {
//                            self.callBack(nil, nil, 0);
//                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:kHouseInfoNeedRefresh object:@"4"];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }else {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                }else {
                    [self showToastMsg:data Duration:3.0];
                }
                
            });
            
        }];

    }
    
    if (sender.tag == 2) {
        
        L_DatePickerViewController *dateVC = [L_DatePickerViewController getInstance];
        dateVC.minDate = beginMinDate;
        [dateVC showVC:self withTitle:@"开始日期" cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            
            if (index == 2) {
                NSLog(@"%@",data);
                beginDate = [XYString IsNotNull:data];
                _startDate_Label.text = beginDate;
            }
            
        }];
        
    }
    
    if (sender.tag == 3) {
        
        L_DatePickerViewController *dateVC = [L_DatePickerViewController getInstance];
        dateVC.minDate = beginDate;
        [dateVC showVC:self withTitle:@"结束日期" cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            
            if (index == 2) {
                NSLog(@"%@",data);
                endDate = [XYString IsNotNull:data];
                _endDate_Label.text = endDate;
            }
            
        }];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _name_TF.text = @"";
    _phone_TF.text = @"";
    
    _endDate_Label.text = @"请选择结束日期";
    
    beginMinDate = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
    _startDate_Label.text = beginMinDate;
    [self getAppsystemTime];/** 获取系统时间 */
    
    beginDate = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
    endDate = @"";
    
    if (_isNeedMsg) {
        _bottomBgView.hidden = NO;
    }else {
        _bottomBgView.hidden = YES;
    }
    
    [self setupRightNavBtn];
    
    //通讯录权限
    [self accessTheAddress];
    
}

#pragma mark - 设置导航右按钮

- (void)setupRightNavBtn {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"帮助" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kNewRedColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = DEFAULT_FONT(14);
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn addTarget:self action:@selector(rightButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}

- (void)rightButtonDidClick {
    
    [self.view endEditing:YES];

    NSLog(@"帮助");
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url = @"http://actives.usnoon.com/Actives/achtml/20170811/index.html";
    webVc.title=@"帮助";
    [self.navigationController pushViewController:webVc animated:YES];
    
}

/**
 *  初始化系统通讯录
 */
- (void)setUpAddressInfo {
    
    if (accessGranted) {
        
        if (IOS9_OR_LATER) {
            
            CNContactPickerViewController *contactVC = [[CNContactPickerViewController alloc] init];
            
            contactVC.delegate = self;
            
            [self presentViewController:contactVC animated:YES completion:nil];
            
        }else {
            
            ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
            nav.peoplePickerDelegate = self;
            nav.delegate = self;
            if(IOS8_OR_LATER){
                nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            }
            
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
    
    if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusNotDetermined){
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
        
        _name_TF.text = [XYString IsNotNull:peopleName];
        _phone_TF.text = [XYString IsNotNull:phoneNum];
        
        NSLog(@"peopleName===%@=====phoneNum===%@",peopleName,phoneNum);
        [picker dismissViewControllerAnimated:YES completion:nil];

    }else {
        [self showToastMsg:@"请选择手机号" Duration:3.0];
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
        
        if (peopleName.length > 4) {
            peopleName = [peopleName substringToIndex:4];
        }
        
        _name_TF.text = [XYString IsNotNull:peopleName];
        _phone_TF.text = [XYString IsNotNull:phoneNum];
        
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        
        NSLog(@"peopleName===%@=====phoneNum===%@",peopleName,phoneNum);
        
    }else {
        [self showToastMsg:@"请选择手机号" Duration:3.0];
    }

}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}


@end

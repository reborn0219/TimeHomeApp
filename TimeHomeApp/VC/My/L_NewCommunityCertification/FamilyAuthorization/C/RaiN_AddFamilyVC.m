//
//  RaiN_AddFamilyVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_AddFamilyVC.h"
/**
 *  关连用户通讯录
 */
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "RegularUtils.h"
#import "CommunityManagerPresenters.h"
#import "L_CommunityAuthoryPresenters.h"
@interface RaiN_AddFamilyVC ()<ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate, UINavigationControllerDelegate>
{
    //通讯录权限
    BOOL accessGranted;
}
@end

@implementation RaiN_AddFamilyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //通讯录权限
    [self accessTheAddress];
    
    if (_msgArr != nil) {
        
        _nameTF.text = _msgArr[0];
        _phoneTF.text = _msgArr[1];
        _phoneTF.enabled = NO;
        _addressBtn.userInteractionEnabled = NO;
        
    }else {
        
        _nameTF.text = @"";
        _phoneTF.text = @"";
        _phoneTF.enabled = YES;
        _addressBtn.userInteractionEnabled = YES;
        
    }
    
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.navigationItem.title = @"添加家人";
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    
}

#pragma mark ------- 接口相关
///添加家人
- (void)addFamilyNet {
    /**
     *  保存住宅授权信息
     */
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [CommunityManagerPresenters saveResidencePowerPowertype:@"0" residenceid:_theID phone:_phoneTF.text name:_nameTF.text rentbegindate:@"" rentenddate:@"" UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                [selfWeak showToastMsg:@"授权成功" Duration:2.0];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kHouseInfoNeedRefresh object:@"3"];

                [[NSNotificationCenter defaultCenter] postNotificationName:kCertifyCommunityNeedRefresh object:nil];
                
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
        });
        
    }];
    
}

///编辑家人
- (void)editFamilyNet {
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [L_CommunityAuthoryPresenters changeHomeNameWithID:_theID andName:_nameTF.text andUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
    
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                [selfWeak showToastMsg:@"保存成功" Duration:2.0];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kHouseInfoNeedRefresh object:@"3"];

                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
        });
    }];
    
}


#pragma mark ---- 通讯录权限相关
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

/**
 通讯录
 */
- (IBAction)AddressBookClick:(id)sender {
    
    if (_msgArr != nil) {
        
        return;
        
    }else {
        
        //通讯录匹配
        [self setUpAddressInfo];
        
    }

}

/**
 保存
 */
- (IBAction)saveClick:(id)sender {
    [self.view endEditing:YES];
    
    if (_nameTF.text.length <= 0) {
        [self showToastMsg:@"您还没有填写被授权人姓名" Duration:3.0f];
        return;
    }
    if (_phoneTF.text.length <= 0) {
        [self showToastMsg:@"请输入被授权人手机号码" Duration:3.0f];
        return;
    }
    
    if (![RegularUtils isPhoneNum:_phoneTF.text]) {
        [self showToastMsg:@"请检查手机号码是否输入正确" Duration:3.0f];
        return;
    }
    
    AppDelegate *appdele = GetAppDelegates;
    NSString *userPhone = appdele.userData.phone;
    if ([_phoneTF.text isEqualToString:userPhone]) {
        [self showToastMsg:@"被授权人不能是登录人" Duration:3.0f];
        return;
    }
    
    if (_msgArr != nil) {
        //编辑
        [self editFamilyNet];
    }else {
        //添加
        [self addFamilyNet];
    }
    
}

- (IBAction)nameTFEditingChange:(id)sender {
    UITextField *tf = sender;
    UITextRange * selectedRange = tf.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(tf.text.length >= 4)
        {
            tf.text = [tf.text substringToIndex:4];
        }
    }
}
- (IBAction)phoneTFEditingChange:(id)sender {
    UITextField *tf = sender;
    UITextRange * selectedRange = tf.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(tf.text.length >= 11)
        {
            tf.text = [tf.text substringToIndex:11];
        }
    }
}



#pragma mark ----- 通讯录相关
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
        _phoneTF.text = @"";
        _nameTF.text = @"";
        
        _phoneTF.text = [_phoneTF.text stringByAppendingFormat:@"%@",phoneNO];
        if (![XYString isBlankString:contact.familyName]) {
            _nameTF.text = [_nameTF.text stringByAppendingFormat:@"%@",contact.familyName];
        }
        if (![XYString isBlankString:contact.givenName]) {
            _nameTF.text = [_nameTF.text stringByAppendingFormat:@"%@",contact.givenName];
        }
        
        if (_nameTF.text.length > 4) {
            _nameTF.text = [_nameTF.text substringToIndex:4];
        }
        
        return;
        
    }else {
        [self showToastMsg:@"请选择正确的手机号" Duration:2.0];
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
        _phoneTF.text = @"";
        _nameTF.text = @"";
        
        _phoneTF.text = [_phoneTF.text stringByAppendingFormat:@"%@",phoneNO];
        if (![XYString isBlankString:firstName]) {
            _nameTF.text = [_nameTF.text stringByAppendingFormat:@"%@",firstName];
        }
        if (![XYString isBlankString:middlename]) {
            _nameTF.text = [_nameTF.text stringByAppendingFormat:@"%@",middlename];
        }
        if (![XYString isBlankString:lastName]) {
            _nameTF.text = [_nameTF.text stringByAppendingFormat:@"%@",lastName];
        }
        if (_nameTF.text.length > 4) {
            _nameTF.text = [_nameTF.text substringToIndex:4];
        }
        //        peopleName = [peopleName stringByAppendingFormat:@"%@%@%@",firstName,middlename,lastName];
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return;
    }else {
        [self showToastMsg:@"请选择正确的手机号" Duration:2.0];
    }
    
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

@end

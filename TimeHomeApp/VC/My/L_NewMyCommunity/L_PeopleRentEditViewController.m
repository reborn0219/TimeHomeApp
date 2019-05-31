//
//  L_PeopleRentEditViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PeopleRentEditViewController.h"

/**
 *  判断手机号
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

#import "MMDateView.h"
#import "MMPopupWindow.h"

@interface L_PeopleRentEditViewController () <ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate, UINavigationControllerDelegate>
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
}
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

/**
 内容高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightLayoutConstraint;

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;

/**
 开始日期
 */
@property (nonatomic, strong) NSString *startDateString;
/**
 结束日期
 */
@property (nonatomic, strong) NSString *endDateString;

@end

@implementation L_PeopleRentEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _startDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
    if ([XYString isBlankString:_startDateString]) {
        _startDateLabel.text = @"开始日期";
    }else {
        _startDateLabel.text = _startDateString;
    }
    
    _endDateLabel.text = @"结束日期";
    
    //通讯录权限
    [self accessTheAddress];
    
    _contentViewHeightLayoutConstraint.constant = SCREEN_HEIGHT - 16 - 64;
    
    _nameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"受租方姓名" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x9A9A9A),NSFontAttributeName:DEFAULT_FONT(14)}];
    _phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"受租方手机号" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x9A9A9A),NSFontAttributeName:DEFAULT_FONT(14)}];

    _bgView1.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView1.layer.borderWidth = 1;
    _bgView2.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView2.layer.borderWidth = 1;
    _bgView3.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView3.layer.borderWidth = 1;
    _bgView4.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView4.layer.borderWidth = 1;
    
    //----------提示框的默认按钮设置---------------------
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
}

// MARK: - 按钮点击
- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    //tag 1.通讯录 2.授权 3.开始日期 4.结束日期
    NSLog(@"点击了%ld",(long)sender.tag);
    if (sender.tag == 1) {
        
        [self setUpAddressInfo];
        
    }else if (sender.tag == 2) {
        
        NSLog(@"授权");
        
    }else if (sender.tag == 3) {
        
        MMDateView *dateView = [[MMDateView alloc]init];
        [dateView show];
        dateView.titleLabel.text = @"开始日期";
        if (![XYString isBlankString:_startDateString]) {
            
            NSDate *startDate = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",_startDateString] withFormat:@"yyyy-MM-dd"];
            dateView.datePicker.date = startDate;
            
            //            NSDate *minDate = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",_startDateString] withFormat:@"yyyy-MM-dd"];
            //            dateView.datePicker.minimumDate = minDate;
            
        }else {
            dateView.datePicker.date = [NSDate date];
        }
        if (![XYString isBlankString:_endDateString]) {
            NSDate *endDate = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",_endDateString] withFormat:@"yyyy-MM-dd"];
            dateView.datePicker.maximumDate = endDate;
        }
        dateView.confirm = ^(NSString *data) {
            
            NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",data] withFormat:@"yyyy/MM/dd"];
            NSString *str = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
            
            _startDateString = str;
            
            _startDateLabel.text = _startDateString;
        };

        
    }else if (sender.tag == 4) {
        
        MMDateView *dateView = [[MMDateView alloc]init];
        [dateView show];
        dateView.titleLabel.text = @"结束日期";
        if (![XYString isBlankString:_startDateString]) {
            
            NSDate *minDate = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",_startDateString] withFormat:@"yyyy-MM-dd"];
            dateView.datePicker.minimumDate = minDate;
            
        }
        
        dateView.confirm = ^(NSString *data) {
            
            NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",data] withFormat:@"yyyy/MM/dd"];
            NSString *str = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
            
            _endDateString = str;
            
            _endDateLabel.text = _endDateString;
        };

        
    }
    
}
- (IBAction)allTFEditingChanged:(UITextField *)sender {
    //tag 1.姓名 2.手机号
    if (sender == _nameTF) {
        
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 6)
            {
                sender.text=[sender.text substringToIndex:6];
            }
        }
        
    }else if (sender == _phoneTF) {
        
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 11)
            {
                sender.text=[sender.text substringToIndex:11];
            }
        }
        
    }
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
        
        if (peopleName.length >= 6) {
            peopleName = [peopleName substringToIndex:6];
        }
        
        if (phoneNum.length >= 11) {
            phoneNum = [phoneNum substringToIndex:11];
        }
        
        _nameTF.text = [XYString IsNotNull:peopleName];
        _phoneTF.text = [XYString IsNotNull:phoneNum];
        
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
        
        if (peopleName.length >= 6) {
            peopleName = [peopleName substringToIndex:6];
        }
        
        if (phoneNum.length >= 11) {
            phoneNum = [phoneNum substringToIndex:11];
        }
        
        _nameTF.text = [XYString IsNotNull:peopleName];
        _phoneTF.text = [XYString IsNotNull:phoneNum];
        
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

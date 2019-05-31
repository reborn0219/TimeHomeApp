//
//  PACarportRentViewController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarportRentViewController.h"
#import "PACarSpaceRentTableViewCell.h"
#import "PACarSpaceRentHeaderView.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "RegularUtils.h"
#import "PACarSpaceRentService.h"
#import "PACarSpaceModel.h"
#import "PACarSpaceRenewService.h"
@interface PACarportRentViewController ()<UITableViewDelegate,UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate>
{
    BOOL accessGranted; //通讯录权限
}
@property (nonatomic, strong) UITableView * rootView;
/**
 出租service
 */
@property (nonatomic, strong) PACarSpaceRentService * rentService;
/**
 续租service
 */
@property (nonatomic, strong) PACarSpaceRenewService * renewService;
@end

@implementation PACarportRentViewController

#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.rentType == PAParkingSpaceRent) {
        self.title = @"车位出租";
    } else if (self.rentType == PAParkingSpaceRenew) {
        self.title = @"续租";
    }
    
    [self.view addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self accessTheAddress];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)rootView{
    if (!_rootView) {
        _rootView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _rootView.delegate = self;
        _rootView.dataSource = self;
        _rootView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootView.backgroundColor = UIColorHex(0xF5F5F5);
    }
    return _rootView;
}
- (PACarSpaceRentService *)rentService{
    if (!_rentService) {
        _rentService = [[PACarSpaceRentService alloc]init];
    }
    return _rentService;
}
- (PACarSpaceRenewService *)renewService{
    if (!_renewService) {
        _renewService = [[PACarSpaceRenewService alloc]init];
    }
    return _renewService;
}

#pragma mark - IBActions/Event Response

/**
 比较结束日期是否大于开始日期

 @param startTime 开始时间 yyyy-mm-dd
 @param endTime 结束时间 yyyy-mm-dd
 @return 是否合法
 */
- (BOOL)timeCompareRightfulWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDate * startDate = [NSDate dateWithString:[startTime stringByAppendingString:@" 00:00:00"] format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * endDate = [NSDate dateWithString:[endTime stringByAppendingString:@" 00:00:00"] format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timerInterval = [endDate timeIntervalSinceDate:startDate];
    if (timerInterval >= 0) {
        return YES;
    }
    return NO;
}

/**
 刷新手机号 姓名
 
 @param phoneNumber 手机号
 @param name 姓名
 */
- (void)reloadPhoneNumber:(NSString *)phoneNumber name:(NSString *)name{
    
    PACarSpaceRentTableViewCell * phoneCell = [self.rootView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    phoneCell.contentString = phoneNumber;
    PACarSpaceRentTableViewCell * nameCell =[self.rootView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    nameCell.contentString = name;
}

/**
 车位出租
 */
- (void)rentAction{
    self.editing = NO;
    // 组成json数据
    PACarSpaceRentTableViewCell * phoneCell = [self.rootView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString * phone =phoneCell.contentString;
    
    PACarSpaceRentTableViewCell * nameCell = [self.rootView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString * name =nameCell.contentString ?:@"";
    
    PACarSpaceRentTableViewCell * startCell = [self.rootView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString * startDate =startCell.contentString;
    
    PACarSpaceRentTableViewCell * endCell = [self.rootView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString * endDate =endCell.contentString;
    
    if (![phone isNotBlank]) {
        [self showToastMsg:@"请先输入被授权人手机号！" Duration:3];
        return;
    }
    if (![name isNotBlank]) {
        [self showToastMsg:@"请先输入被授权人姓名！" Duration:3];
        return;
    }
    
    if(![RegularUtils isPhoneNum:phone])//验证手机号正确
    {
        [self showToastMsg:@"请输入正确的手机号码！" Duration:3];

        return;
    }
    // 开始日期如果大于结束日期 提示错误 return;
    BOOL rightfulTime = [self timeCompareRightfulWithStartTime:startDate endTime:endDate];
    
    if (!rightfulTime) {
        [self showToastMsg:@"出租结束日期需大于开始日期" Duration:3];
        return;
    }
    
    [self.rentService rentRequestWithSpaceId:self.spaceModel.spaceId userName:name userPhone:phone startDate:startDate endDate:endDate success:^(id responseObject) {
        if (self.rentSuccessBlock) {
            self.rentSuccessBlock(nil, 0);
        }
        [self showToastMsg:@"出租成功" Duration:2.35];

        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        [self showAlertMessage:error.userInfo[@"NSLocalizedDescription"] Duration:3];
    }];
}

/**
 续租车位
 */
- (void)renewAction{
    self.editing = NO;
    PACarSpaceRentTableViewCell * startCell = [self.rootView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString * startDate =startCell.contentString;
    
    PACarSpaceRentTableViewCell * endCell = [self.rootView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString * endDate =endCell.contentString;
    
    
    // 开始日期如果大于结束日期 提示错误 return;
    BOOL rightfulTime = [self timeCompareRightfulWithStartTime:startDate endTime:endDate];
    
    if (!rightfulTime) {
        [self showToastMsg:@"出租结束日期需大于开始日期" Duration:3];
        return;
    }
    
    [PACarSpaceRenewService rentRequestWithSpaceId:self.spaceModel.spaceId startDate:startDate endDate:endDate success:^(id responseObject) {
        
        [self showToastMsg:@"续租成功" Duration:2.35];
        if (self.rentSuccessBlock) {
            self.rentSuccessBlock(nil, 0);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [self showToastMsg:@"续租失败" Duration:2.35];
        
    }];
}

#pragma mark - TableViewDelegate/Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.rentType == PAParkingSpaceRent) {
        return self.rentService.titleArray.count;
    } else if (self.rentType == PAParkingSpaceRenew){
        return self.renewService.titleArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.rentType == PAParkingSpaceRenew) {
        return 0;
    }
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PACarSpaceRentHeaderView * header = [[PACarSpaceRentHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    header.titleLabel.text = self.spaceModel.parkingSpaceName;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    PACarSpaceRentFooterView * footer = [[PACarSpaceRentFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    @WeakObj(self);
    footer.rentBlock = ^(id  _Nullable data, ResultCode resultCode) {
        if (selfWeak.rentType == PAParkingSpaceRenew) {
            [selfWeak renewAction];
        } else {
            
            [selfWeak rentAction];
        }
    };
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * infoCellIdentifier = @"PACarSpaceRentTableViewCell";
    PACarSpaceRentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
    if (!cell) {
        cell = [[PACarSpaceRentTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:infoCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString * placeString;
    NSString * titleString;
    
    if (self.rentType == PAParkingSpaceRent) {
        placeString = self.rentService.placeholderArray[indexPath.row];
        titleString = self.rentService.titleArray[indexPath.row];
    } else if (self.rentType == PAParkingSpaceRenew) {
        placeString = self.renewService.placeholderArray[indexPath.row];
        titleString = self.renewService.titleArray[indexPath.row];
    }
    
    cell.placeString = placeString;
    cell.titleString = titleString;
    cell.maxPickerDate = self.spaceModel.parkingServiceEndDate;
    [cell showAddreBook:indexPath.row == 0 ? YES : NO];
    
    @WeakObj(self)
    cell.addressBlock = ^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        [selfWeak showAddressBook];
    };
    
    if (self.rentType == PAParkingSpaceRent) {
        cell.responseType = indexPath.row >1 ?SelectTime :Default;
    } else if (self.rentType == PAParkingSpaceRenew){
        [cell showAddreBook:NO];
        if (indexPath.row == 0) {
            cell.responseType = UnableEdit;
        } else {
            cell.responseType = SelectTime;
        }
        cell.contentString = indexPath.row==0 ?(self.spaceModel.useEndDate?:@""):@"";
    }
    
    return cell;
}

#pragma mark 通讯录
#pragma mark - 打开通讯录，获取联系人
/**
 *  打开通讯录，获取联系人
 *
 *  @param sender sender description
 */
- (void)showAddressBook {
    self.editing = NO;
    if (accessGranted) {
        if (IOS9_OR_LATER) {
            
            CNContactPickerViewController *contactVC = [[CNContactPickerViewController alloc] init];
            
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
    
    if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusNotDetermined){
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            if (error){
                NSLog(@"Error: %@", (__bridge NSError *)error);
            } else {
                accessGranted = YES;
            }
        });
    } else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusAuthorized){
        accessGranted=YES;
    }
    else
    {
        [self showToastMsg:@"您的通讯录没有开启授权" Duration:3.0];
    }
    return accessGranted;
}

#pragma mark - 选中一个联系人属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    CNContact *contact = contactProperty.contact;
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString *phoneNO = [NSString stringWithFormat:@"%@",phoneNumber.stringValue];
    
    for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
        CNPhoneNumber *phoneNumber = labeledValue.value;
    }
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([RegularUtils isPhoneNum:phoneNO]) {
        
        NSString *phoneNum = @"";
        NSString *peopleName = @"";
        
        phoneNum = [phoneNum stringByAppendingFormat:@"%@",phoneNO];
        if ([contact.familyName isNotBlank]) {
            peopleName = [peopleName stringByAppendingFormat:@"%@",contact.familyName];
        }
        if ([contact.givenName isNotBlank]) {
            peopleName = [peopleName stringByAppendingFormat:@"%@",contact.givenName];
        }
        
        if (peopleName.length > 4) {
            peopleName = [peopleName substringToIndex:4];
        }
        
        [self reloadPhoneNumber:phoneNum name:peopleName];
        
    } else {
        [self showToastMsg:@"请选择手机号" Duration:2.0];
    }
}

#pragma mark -- ABPeoplePickerNavigationControllerDelegate-----
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    NSString * name = (NSString*)CFBridgingRelease(ABRecordCopyCompositeName(person));
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    //电话号码
    CFStringRef telValue = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSString * phone=(__bridge NSString *)telValue;
        
        if ([phone hasPrefix:@"+86"]) {
            phone=[phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        } else if ([phone hasPrefix:@"86"]) {
            phone=[phone substringFromIndex:2];
        } else if ([phone containsString:@"-"]) {
            phone=[phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        [self reloadPhoneNumber:phone name:name];
    }];
    
}

@end

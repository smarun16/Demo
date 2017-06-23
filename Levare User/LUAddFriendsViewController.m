//
//  LUAddFriendsViewController.m
//  Levare User
//
//  Created by angler133 on 08/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUAddFriendsViewController.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

//Cell
#import "LUAddFriendsTableViewCell.h"
#import "LUSectionHeaderTableViewCell.h"


#import "APContact.h"
#import "APAddressBook.h"


#define CONTACT_NAME @"name"
#define MOBILE_NUMBER @"mobile_number"
#define COUNTRY_CODE @"country_code"

@interface LUAddFriendsViewController () <UISearchResultsUpdating, UISearchBarDelegate, UIPopoverListViewDelegate, UIPopoverListViewDataSource>
{
    BOOL isSearching;
    UIPopoverListView *myPopListView;
    NSArray *myContactListArray;
    NSString *myContactNoString;
}

@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;

@property (nonatomic, strong) APAddressBook *addressBook;
@property (nonatomic, strong) NSMutableArray *myContactInfo;
@property (nonatomic, strong) NSMutableArray *myMAryAlphabets;

@property (nonatomic, strong) NSMutableArray *myMArySearchAlphabets;
@property (nonatomic, strong) NSMutableArray *myMArySearchResultsInfo, *myLastContactInfo;
@property (nonatomic, strong) NSArray *myArySearchResults, *myLastArySearchResults;

@property (nonatomic, strong) NSArray *myMAryAtoZ;

@property (strong, nonatomic) NSString *myStrSearchText;

@end

@implementation LUAddFriendsViewController

@synthesize myContactInfo;
@synthesize myMAryAlphabets;
@synthesize myMAryAtoZ;
@synthesize myMArySearchAlphabets, myMArySearchResultsInfo;

#pragma mark - View & Model -

#pragma mark -View Life Cycle


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // setup UI & Content
    [self setupUI];
    [self setupModel];
    
    // Load Contents
    [self loadModel];
}

#pragma mark -View Init

- (void)setupUI {
    
    
    [self setUpNavigationBar];
    
    [self.myTblView registerNib:[UINib nibWithNibName:NSStringFromClass([LUAddFriendsTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LUAddFriendsTableViewCell class])];
    [self.myTblView registerNib:[UINib nibWithNibName:NSStringFromClass([LUSectionHeaderTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LUSectionHeaderTableViewCell class])];
}

#pragma mark -Model

- (void)setupModel {
    
    myContactInfo = [NSMutableArray new];
    _myLastContactInfo = [NSMutableArray new];
    _myLastArySearchResults = [NSArray new];
    myContactListArray = [NSMutableArray new];
    myContactNoString = @"";
    myMArySearchAlphabets = [NSMutableArray new];
    myMArySearchResultsInfo = [NSMutableArray new];
    
    self.addressBook = [[APAddressBook alloc] init];
    [self loadContacts];
}

- (void)loadModel {
    
    
}

#pragma mark - UITable view Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSearching)
        return myMArySearchAlphabets.count;
    
    return myMAryAlphabets.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isSearching) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@",self.myMArySearchAlphabets[section]];
        return [self.myArySearchResults filteredArrayUsingPredicate:predicate].count;
    }
    
    else {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",myMAryAlphabets[section]];
        return [myMAryAtoZ filteredArrayUsingPredicate:predicate].count;
    }
}

// Index Title Count
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isSearching) {
        
        return 0;
    }
    
    return self.myMAryAlphabets;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LUSectionHeaderTableViewCell *aCell = (LUSectionHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LUSectionHeaderTableViewCell class])];
    
    if (isSearching)
        aCell.gLblSectionHeader.text = [HELPER prefixWithWhiteSpaceForText:self.myMArySearchAlphabets[section] numberOfWhileSpace:3];
    
    else
        aCell.gLblSectionHeader.text = [HELPER prefixWithWhiteSpaceForText:myMAryAlphabets[section] numberOfWhileSpace:0];
    
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LUAddFriendsTableViewCell *aCell = (LUAddFriendsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LUAddFriendsTableViewCell class])];
    
    int index = (int)indexPath.row;
    
    for (int i = 0; i < indexPath.section; i++) {
        index += [tableView numberOfRowsInSection:i];
    }
    
    NSMutableDictionary *aDictInfo = [NSMutableDictionary new];
    
    if (isSearching)
        aDictInfo = self.myArySearchResults[index];
    else
        aDictInfo = myContactInfo[index];
    
    aCell.gLblName.text = aDictInfo[CONTACT_NAME];
    aCell.gLblDescription.text = aDictInfo[MOBILE_NUMBER];
    
    [aCell.gImgView setImage:[aDictInfo[IS_CONTACT_SELECTED]boolValue] ? [UIImage imageNamed:ICON_CHECKED] : [UIImage imageNamed:ICON_UNCHECKED]] ;
    
    
    
    
    return aCell;
}
static int aIndex;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    LUAddFriendsTableViewCell *aCell = (LUAddFriendsTableViewCell *)[self.myTblView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    aIndex = (int)indexPath.row;
    
    for (int i = 0; i < indexPath.section; i++) {
        aIndex += [tableView numberOfRowsInSection:i];
    }
    
    NSMutableDictionary *aDictInfo = [NSMutableDictionary new];
    
    if (isSearching) {
        aDictInfo = self.myArySearchResults[aIndex];
        _myLastArySearchResults = _myArySearchResults;
    }
    else {
        aDictInfo = myContactInfo[aIndex];
        _myLastContactInfo = myContactInfo;
    }
    aDictInfo[IS_CONTACT_SELECTED] = [aDictInfo[IS_CONTACT_SELECTED]boolValue] ? @"0" : @"1";
    
    [aCell.gImgView setImage:[aDictInfo[IS_CONTACT_SELECTED]boolValue] ? [UIImage imageNamed:ICON_CHECKED] : [UIImage imageNamed:ICON_UNCHECKED]] ;
    
    myContactListArray = [aDictInfo[MOBILE_NUMBER] componentsSeparatedByString:@","];
    
    if ([aDictInfo[IS_CONTACT_SELECTED] boolValue]) {
        
        if (myContactListArray.count > 1) {
            myPopListView = [[UIPopoverListView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 30), (CGRectGetHeight(self.view.frame) - 30 ), (CGRectGetWidth(self.view.frame) - 30 ), (myContactListArray.count * 50))];
            myContactNoString = @"";
            myPopListView.delegate = self;
            myPopListView.datasource = self;
            [myPopListView show];
            [myPopListView setTitle:[NSString stringWithFormat:@"Choose no. for %@",aDictInfo[CONTACT_NAME]]];
        }
    }
    else {
        
        /*   NSMutableDictionary *aLastDictInfo = [NSMutableDictionary new];
         
         if (isSearching) {
         
         aLastDictInfo = _myLastArySearchResults[aIndex];
         aDictInfo = _myArySearchResults[aIndex];
         
         aDictInfo[MOBILE_NUMBER] = aLastDictInfo[MOBILE_NUMBER];
         }
         else {
         
         aLastDictInfo = myContactInfo[aIndex];
         aDictInfo = _myLastContactInfo[aIndex];
         
         aDictInfo[MOBILE_NUMBER] = aLastDictInfo[MOBILE_NUMBER];
         }*/
    }
}


#pragma mark - Search Bar Delegate Mthods -

#pragma mark - Search Bar Delegate -

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    isSearching = NO;
    searchBar.text = @"";
    
    if (myMArySearchAlphabets.count) {
        
        for (int i= 0; i < self.myArySearchResults.count; i ++) {
            
            NSMutableDictionary *aMDictInfo = [NSMutableDictionary new];
            aMDictInfo = [self.myArySearchResults[i] mutableCopy];
            
            for (int j = 0; j < myContactInfo.count; j ++) {
                
                NSMutableDictionary *aMDictContactInfo = [NSMutableDictionary new];
                aMDictContactInfo = [myContactInfo[j] mutableCopy];
                
                if ([aMDictInfo[CONTACT_NAME] isEqualToString:aMDictContactInfo[CONTACT_NAME]]) {
                    
                    aMDictContactInfo[IS_CONTACT_SELECTED] = aMDictInfo[IS_CONTACT_SELECTED];
                    [myContactInfo replaceObjectAtIndex:j withObject:aMDictContactInfo];
                }
            }
        }
    }
    
    [self loadSectionTitle];
    [self.myTblView reloadDataWithAnimation];
    
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    isSearching = YES;
    
    self.myStrSearchText = searchText;
    
    if (self.myStrSearchText.length == 0) {
        
        isSearching = NO;
        
        if (myMArySearchAlphabets.count) {
            
            for (int i= 0; i < self.myArySearchResults.count; i ++) {
                
                NSMutableDictionary *aMDictInfo = [NSMutableDictionary new];
                aMDictInfo = [self.myArySearchResults[i] mutableCopy];
                
                for (int j = 0; j < myContactInfo.count; j ++) {
                    
                    NSMutableDictionary *aMDictContactInfo = [NSMutableDictionary new];
                    aMDictContactInfo = [myContactInfo[j] mutableCopy];
                    
                    if ([aMDictInfo[CONTACT_NAME] isEqualToString:aMDictContactInfo[CONTACT_NAME]]) {
                        
                        aMDictContactInfo[IS_CONTACT_SELECTED] = aMDictInfo[IS_CONTACT_SELECTED];
                        [myContactInfo replaceObjectAtIndex:j withObject:aMDictContactInfo];
                    }
                }
            }
        }
        
        [self loadSectionTitle];
        
    }
    else {
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"name contains[cd] %@",
                                        searchText];
        
        self.myArySearchResults = [myContactInfo filteredArrayUsingPredicate:resultPredicate];
        
        self.myMArySearchAlphabets = [NSMutableArray new];
        
        for (NSDictionary *aDictInfo in self.myArySearchResults) {
            
            NSString *firstLetter = [[aDictInfo[CONTACT_NAME] substringToIndex:1] uppercaseString];
            
            if (![self.myMArySearchAlphabets containsObject:firstLetter]) {
                [self.myMArySearchAlphabets addObject:firstLetter];
            }
        }
        
        if (myMArySearchAlphabets.count)
            [self hideNoRecordsAlertView];
        
        else {
            // No result found alert
            [self showNoRecordsAlertView];
        }
    }
    [self.myTblView reloadDataWithAnimation];
}



#pragma mark - UIPopover List View Delegate -

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView numberOfRowsInSection:(NSInteger)section
{
    return myContactListArray.count - 1;
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    
    cell.textLabel.text = myContactListArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
}


- (void)popoverListView:(UIPopoverListView *)popoverListView didSelectIndexPath:(NSIndexPath *)indexPath {
    
    myContactNoString = @"";
    myContactNoString = myContactListArray[indexPath.row];
    
    NSMutableDictionary *aDictInfo = [NSMutableDictionary new];
    
    if (isSearching)
        aDictInfo = self.myArySearchResults[aIndex];
    else
        aDictInfo = myContactInfo[aIndex];
    
    aDictInfo[MOBILE_NUMBER] = myContactNoString;
    
    [_myTblView reloadDataWithAnimation];
}

- (void)popoverListViewCancel:(UIPopoverListView *)popoverListView {
    
    if (!myContactNoString.length) {
        
        NSMutableDictionary *aDictInfo = [NSMutableDictionary new];
        
        if (isSearching)
            aDictInfo = self.myArySearchResults[aIndex];
        else
            aDictInfo = myContactInfo[aIndex];
        
        aDictInfo[IS_CONTACT_SELECTED] = @"0";
        
        [_myTblView reloadDataWithAnimation];
    }
}

#pragma mark - UIButton methods -

- (void)leftBarButtonTapEvent {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonTapEvent {
    
    
    if (myContactInfo.count == 0) {
        
        [HELPER showNotificationSuccessIn:self withMessage:@"Please add any one of contact"];
        return;
    }
    
    NSMutableArray *aMAryUserInfo =  [SESSION getUserInfo];
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        [HELPER showNotificationSuccessIn:self withMessage:ALERT_NO_INTERNET];
        return;
    }
    
    NSMutableArray *aAddMutableArray = [NSMutableArray new];
    NSMutableDictionary *aMutableDictJsonTitle = [NSMutableDictionary new];
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    for (NSDictionary *aDictInfo in myContactInfo) {
        
        NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
        
        if ([aDictInfo[IS_CONTACT_SELECTED] boolValue]) {
            
            aMutableDict[@"Family_Id"] = @"";
            aMutableDict[@"Customer_Id"] = aMAryUserInfo[0][K_CUSTOMER_ID];
            aMutableDict[@"Name"] = aDictInfo[CONTACT_NAME];
            
            // This is to remove special char. in mobile no.
            NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
            
            aMutableDict[@"Mobile_Number"] = [[aDictInfo[MOBILE_NUMBER] componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
            aMutableDict[@"Country_Code"] = [[SESSION getUserInfo][0][@"Country_Code"] substringFromIndex:1];
            
            [aAddMutableArray addObject:aMutableDict];
        }
    }
    
    if (aAddMutableArray.count)
        aMutableDictJsonTitle[@"Family_Info"] = aAddMutableArray;
    
    else {
        
        [HELPER showNotificationSuccessIn:self withMessage:@"Please add any one of contact"];
        return;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aMutableDictJsonTitle options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [self.view endEditing:YES];
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER addContactToWebservice:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aInfoMutableArray = [NSMutableArray new];
            
            aInfoMutableArray = response[@"Family_Info"];
            
            [HELPER showAlertView:self title:SCREEN_TITLE_ADD_CONATACTS message:response[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                    if (_callBackBlock) {
                        
                        _callBackBlock(YES, aInfoMutableArray);
                    }
                }];
            }];
        }
        
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
        
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        if (error.code == NSURLErrorTimedOut)
            [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
                
                if ([HTTPMANAGER isNetworkRechable]) {
                    
                    [HELPER removeRetryAlertIn:self];
                    [HELPER showLoadingIn:self];
                    [self rightBarButtonTapEvent];
                }
            }];
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
    
}

#pragma mark - ABPeoplePickerNavigationController Delegate method implementation

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    // Initialize a mutable dictionary and give it initial values.
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"", @"", @"", @"", @"", @"", @"", @"", @""]
                                            forKeys:@[@"firstName", @"lastName", @"mobileNumber", @"homeNumber", @"homeEmail", @"workEmail", @"address", @"zipCode", @"city"]];
    
    // Use a general Core Foundation object.
    CFTypeRef generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // Get the first name.
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    
    // Get the last name.
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
    }
    
    // Get the phone numbers as a multi-value property.
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }
        
        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
        }
        
        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
    }
    CFRelease(phonesRef);
    
    
    // Get the e-mail addresses as a multi-value property.
    ABMultiValueRef emailsRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i=0; i<ABMultiValueGetCount(emailsRef); i++) {
        CFStringRef currentEmailLabel = ABMultiValueCopyLabelAtIndex(emailsRef, i);
        CFStringRef currentEmailValue = ABMultiValueCopyValueAtIndex(emailsRef, i);
        
        if (CFStringCompare(currentEmailLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"homeEmail"];
        }
        
        if (CFStringCompare(currentEmailLabel, kABWorkLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"workEmail"];
        }
        
        CFRelease(currentEmailLabel);
        CFRelease(currentEmailValue);
    }
    CFRelease(emailsRef);
    
    
    // Get the first street address among all addresses of the selected contact.
    ABMultiValueRef addressRef = ABRecordCopyValue(person, kABPersonAddressProperty);
    if (ABMultiValueGetCount(addressRef) > 0) {
        NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
        
        [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressStreetKey] forKey:@"address"];
        [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressZIPKey] forKey:@"zipCode"];
        [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressCityKey] forKey:@"city"];
    }
    CFRelease(addressRef);
    
    
    // If the contact has an image then get it too.
    if (ABPersonHasImageData(person)) {
        NSData *contactImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        
        [contactInfoDict setObject:contactImageData forKey:@"image"];
    }
    
    
    // Dismiss the address book view controller.
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}


-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - private

- (void)loadContacts
{
    [HELPER showLoadingIn:self text:@"Fetching contact.."];
    
    self.addressBook.fieldsMask = APContactFieldAll;
    self.addressBook.sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"name.firstName" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"name.lastName" ascending:YES]];
    self.addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
    [self.addressBook loadContacts:^(NSArray<APContact *> *contacts, NSError *error) {
        
        if (contacts)
        {
            [HELPER removeLoadingIn:self];
            
            for (int i = 0; i < contacts.count; i++) {
                [self updateContactDetails:contacts[i]];
            }
            
            [self loadSectionTitle];
            [self.myTblView reloadDataWithAnimation];
        }
        
        else if (error)
        {
            [HELPER removeLoadingIn:self];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

NSString* const nonBreakingSpace = @"\u00a0";

- (void)updateContactDetails:(APContact *)contact {
    
    NSMutableDictionary *aMDictInfo = [NSMutableDictionary new];
    
    // Set the contact details
    if (contact.name.compositeName)
        aMDictInfo[CONTACT_NAME] = contact.name.compositeName;
    
    else if (contact.name.firstName && contact.name.lastName)
        aMDictInfo[CONTACT_NAME] = [NSString stringWithFormat:@"%@ %@", contact.name.firstName, contact.name.lastName];
    
    else if (contact.name.firstName || contact.name.lastName)
        aMDictInfo[CONTACT_NAME] = contact.name.firstName ?: contact.name.lastName;
    
    else
        aMDictInfo[CONTACT_NAME] =  @"Untitled contact";
    
    // Set the mobile number
    if (contact.phones.count > 0) {
        
        NSMutableString *result = [[NSMutableString alloc] init];
        
        if (contact.phones.count > 1) {
            
            for (APPhone *phone in contact.phones) {
                
                if (phone.number.length) {
                    
                    NSString *string = phone.localizedLabel.length == 0 ? phone.number :
                    [NSString stringWithFormat:@"%@", phone.number];
                    [result appendFormat:@"%@,", string];
                    
                    aMDictInfo[MOBILE_NUMBER] =  result;
                }
            }
        }
        else {
            
            for (APPhone *phone in contact.phones) {
                
                if (phone.number.length) {
                    
                    NSString *string = phone.localizedLabel.length == 0 ? phone.number :
                    [NSString stringWithFormat:@"%@", phone.number];
                    //  string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [result appendFormat:@"%@", string];

                    aMDictInfo[MOBILE_NUMBER] =  result;
                }
            }
        }
        
    }
    else {
        
        aMDictInfo[MOBILE_NUMBER] =  @"";
    }
    
    
    aMDictInfo[IS_CONTACT_SELECTED] =  @"0";
    
    
    if (_gMAryInfo.count) {
        
        for (NSDictionary *aDict in _gMAryInfo) {
            
            if ([aDict[@"Name"] isEqualToString: aMDictInfo[CONTACT_NAME]]) {
                
                NSString *countryCode = [SESSION getUserInfo][0][@"Country_Code"];
                
                NSString *aMobileNoString = [aDict[@"Mobile_Number"] stringByReplacingOccurrencesOfString:countryCode withString:@""];
                
                aMDictInfo[IS_CONTACT_SELECTED] =  @"1";
                aMDictInfo[MOBILE_NUMBER] =  aMobileNoString;
            }
        }
    }
    
    [myContactInfo addObject:aMDictInfo];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:CONTACT_NAME ascending:YES];
    [myContactInfo sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
}


// Get the Alphabets
- (void)loadSectionTitle
{
    { // For Section Title
        
        myMAryAlphabets = [NSMutableArray new];
        
        myMAryAtoZ = [myContactInfo valueForKey:CONTACT_NAME];
        
        myMAryAtoZ  = [myMAryAtoZ sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        for (int i = 0; i < myMAryAtoZ.count; i++) {
            
            NSString *shopName = [myMAryAtoZ objectAtIndex:i];
            NSString *firstLetter = [[shopName substringToIndex:1] uppercaseString];
            
            if (![myMAryAlphabets containsObject:firstLetter]) {
                [myMAryAlphabets addObject:firstLetter];
            }
        }
    }
}

#pragma mark - Helper -

- (void)setUpNavigationBar {
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVIGATION_COLOR;
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.layer.shadowColor = (__bridge CGColorRef _Nullable)(WHITE_COLOUR);
    
    // TO SET TILE COLOR & FONT
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:FONT_HELVETICA_NEUE size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = WHITE_COLOUR;
    self.navigationItem.titleView = label;
    label.text = SCREEN_TITLE_ADD_CONATACTS;
    [label sizeToFit];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:CANCEL style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapEvent)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:SAVE style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTapEvent)];
}

- (void)showNoRecordsAlertView {
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.myLblSearchAlert.text = [NSString stringWithFormat:@"No contacts found for \"%@\"",self.myStrSearchText];
        
        self.myLblSearchAlert.alpha = 1.0;
        self.myTblView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)hideNoRecordsAlertView {
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.myLblSearchAlert.alpha = 0.0;
        self.myTblView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

@end

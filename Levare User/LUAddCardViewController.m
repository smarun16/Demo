//
//  LUAddCardViewController.m
//  Levare User
//
//  Created by Arun Prasad.S, ANGLER - EIT on 02/01/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

#import "LUAddCardViewController.h"
#import "CardTableViewCell.h"


#import "BKCardNumberField.h"
#import "BKCardExpiryField.h"

#import "CardIOPaymentViewControllerDelegate.h"
#import "CardIO.h"
#import "NTMonthYearPicker.h"

@interface LUAddCardViewController ()<UITextFieldDelegate, CardIOPaymentViewControllerDelegate>
{
    NSDateComponents *myComponents;
    NSDateFormatter *myDateFormatter;
    UIDatePicker *myDatePicker;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *cardName;
@property (strong, nonatomic) NSString *cardExpiryDate, *myCardExpireDate;
@property (strong, nonatomic) NSString *cardCVV;
@property (strong, nonatomic) NSString *cardHolderName;
@property (strong, nonatomic) NSString *cardNickName;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@end

@implementation LUAddCardViewController {
    
    NSInteger rowCount;
}

@synthesize submitButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self classAndWidgetsInitialize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardTableViewCell *cell;
    
    if (indexPath.row == 0) {
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"CardTableViewCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.cardNumberTextField.showsCardLogo = YES;
        cell.cardNumberTextField.cardNumber = self.cardNumber;
        cell.cardNumberTextField.delegate = self;
        
        [cell.cardNumberTextField addTarget:self action:@selector(cardNumberEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        self.cardName = cell.cardNumberTextField.cardCompanyName;
        
        {
            
            cell.cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
            cell.cardNumberTextField.tag = 1;
            
            //LABEL
            UILabel *formatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 23)];
            formatLabel.textAlignment = NSTextAlignmentLeft;
            formatLabel.backgroundColor = COLOR_CLEAR;
            formatLabel.shadowOffset = CGSizeMake(0, 1);
            formatLabel.textColor = WHITE_COLOUR;
            formatLabel.text = @"Card number";
            formatLabel.font = [UIFont fontWithName:FONT_MEDIUM_FONT size:18.0];
            
            //Next BUTTON
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithCustomView:formatLabel];
            
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Next " style:UIBarButtonItemStyleDone target:self action:@selector(cardNumberNextButtonTapped)];
            doneItem.tintColor = WHITE_COLOUR;
            
            UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[self class] toolbarHeight])];
            [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace,flexableItem,doneItem, nil]];
            toolbar.barStyle = UIBarStyleBlackTranslucent;
            [toolbar setBackgroundColor:[HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY]];
            
            cell.cardNumberTextField.inputAccessoryView = toolbar;
        }
    }
    
    else if (indexPath.row == 1) {
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CardTableViewCell" owner:self options:nil][1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        cell.cardHolderNameTextField.tag = 2;
        cell.cardHolderNameTextField.delegate = self;
        cell.cardHolderNameTextField.text = self.cardHolderName;
        cell.cardHolderNameTextField.returnKeyType = UIReturnKeyNext;
    }
    else {
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CardTableViewCell" owner:self options:nil][2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        /*     {
         
         //LABEL
         UILabel *formatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 23)];
         formatLabel.textAlignment = NSTextAlignmentLeft;
         formatLabel.backgroundColor = COLOR_CLEAR;
         formatLabel.shadowOffset = CGSizeMake(0, 1);
         formatLabel.textColor = WHITE_COLOUR;
         formatLabel.text = @"Card Expiry Month, Year";
         formatLabel.font = [UIFont fontWithName:FONT_MEDIUM_FONT size:18.0];
         
         //Next BUTTON
         UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithCustomView:formatLabel];
         
         UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Next " style:UIBarButtonItemStyleDone target:self action:@selector(expiryNextButtonTapped)];
         doneItem.tintColor = WHITE_COLOUR;
         doneItem.tag = cell.cardExpiryDate.tag;
         
         UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
         
         UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[self class] toolbarHeight])];
         [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace,flexableItem,doneItem, nil]];
         [toolbar setBackgroundColor:[HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY]];
         toolbar.barStyle = UIBarStyleBlackTranslucent;
         
         cell.cardExpiryDate.inputAccessoryView = toolbar;
         }
         
         myDateFormatter = [[NSDateFormatter alloc] init];
         myDateFormatter.dateStyle = NSDateFormatterMediumStyle;
         [myDateFormatter setDateFormat:@"MM/yy"];
         
         myDatePicker = [[UIDatePicker alloc] init];
         myDatePicker.datePickerMode = UIDatePickerModeDate;
         [myDatePicker setDate:[myDateFormatter dateFromString:_cardExpiryDate]];
         [myDatePicker setMinimumDate:[NSDate date]];
         myDatePicker.tag = 250;
         [myDatePicker addTarget:self action:@selector(datePickerClicked:) forControlEvents:UIControlEventValueChanged];
         [myDatePicker reloadInputViews];
         
         cell.cardExpiryDate.tag = 3;
         cell.cardExpiryDate.inputView = myDatePicker;*/
        
        NSArray *array = [self.cardExpiryDate componentsSeparatedByString:@", "];
        NSDateComponents *dateComp;
        
        if ([array count] != 0) {
            
            dateComp = [NSDateComponents new];
            dateComp.month = [array[0] integerValue];
            dateComp.year = [array[1] integerValue];
            
            cell.cardExpiryDate.dateComponents = dateComp;
        }
        
        cell.cardExpiryDate.tag = 3;
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NTMonthYearPicker *datePicker = [[NTMonthYearPicker alloc] init];
        datePicker.tag = 5;
        datePicker.datePickerMode = NTMonthYearPickerModeMonthAndYear;
        datePicker.minimumDate = [NSDate date];
        [datePicker setDate:[cal dateFromComponents:dateComp] animated:YES];
        
        [datePicker addTarget:self action:@selector(expireDateValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.cardExpiryDate.inputView = datePicker;
        
        {
            
            //LABEL
            UILabel *formatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 23)];
            formatLabel.textAlignment = NSTextAlignmentLeft;
            formatLabel.backgroundColor = COLOR_CLEAR;
            formatLabel.shadowOffset = CGSizeMake(0, 1);
            formatLabel.textColor = WHITE_COLOUR;
            formatLabel.text = @"Card Expiry Month, Year";
            formatLabel.font = [UIFont fontWithName:FONT_MEDIUM_FONT size:18.0];
            
            //Next BUTTON
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithCustomView:formatLabel];
            
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Next " style:UIBarButtonItemStyleDone target:self action:@selector(expiryNextButtonTapped)];
            doneItem.tintColor = WHITE_COLOUR;
            doneItem.tag = cell.cardExpiryDate.tag;
            
            UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[self class] toolbarHeight])];
            [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace,flexableItem,doneItem, nil]];
            [toolbar setBackgroundColor:[HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY]];
            toolbar.barStyle = UIBarStyleBlackTranslucent;
            
            cell.cardExpiryDate.inputAccessoryView = toolbar;
        }
        
        {
            
            cell.cardCVV.keyboardType = UIKeyboardTypeNumberPad;
            
            //LABEL
            UILabel *formatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 23)];
            formatLabel.textAlignment = NSTextAlignmentLeft;
            formatLabel.backgroundColor = COLOR_CLEAR;
            formatLabel.shadowOffset = CGSizeMake(0, 1);
            formatLabel.textColor = WHITE_COLOUR;
            formatLabel.text = @"CVV";
            formatLabel.font = [UIFont fontWithName:FONT_MEDIUM_FONT size:18.0];
            
            //DONE BUTTON
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithCustomView:formatLabel];
            
            NSString *aTitle = @"Done ";
            
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:aTitle style:UIBarButtonItemStyleDone target:self action:@selector(cvvNextButtonTapped)];
            doneItem.tintColor = WHITE_COLOUR;
            
            UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[self class] toolbarHeight])];
            [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace,flexableItem,doneItem, nil]];
            toolbar.barStyle = UIBarStyleBlackTranslucent;
            [toolbar setBackgroundColor:[HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY]];
            
            cell.cardCVV.inputAccessoryView = toolbar;
        }
        cell.cardCVV.tag = 4;
        cell.cardCVV.delegate = self;
        cell.cardCVV.text = self.cardCVV;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

#pragma mark - TextField Delegate

- (void)cardNumberEditingChanged:(BKCardNumberField *)textField {
    
    self.cardNumber = textField.cardNumber;
    self.cardName = textField.cardCompanyName;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    if (textField.tag == 1) {
        
        [[_tableView viewWithTag:2] becomeFirstResponder];
    }
    else if (textField.tag == 2) {
        
        [[_tableView viewWithTag:3] becomeFirstResponder];
    }
    else
        [self.view endEditing:YES];
    
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *aUpdateString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 1) {
        
        if ([aUpdateString containsString:@" "]) {
            if (aUpdateString.length <= 19) {
                
                self.cardNumber = aUpdateString;
                return YES;
            }
            else
                return NO;
        }
        else {
            if (aUpdateString.length <= 16) {
                
                self.cardNumber = aUpdateString;
                return YES;
            }
            else
                return NO;
        }
    }
    
    else if (textField.tag == 2)
        self.cardHolderName = aUpdateString;
    
    else if (textField.tag == 3)
        self.cardExpiryDate = aUpdateString;
    
    else {
        
        if (aUpdateString.length > 3)
            return NO;
        
        self.cardCVV = aUpdateString;
    }
    return YES;
}


#pragma mark - Private Methods

- (void)classAndWidgetsInitialize {
    
    if (_aDictionary.count)
        [NAVIGATION setTitleWithBarButtonItems:@"UPDATE CARD" forViewController:self showLeftBarButton:@"icon_back.png" showRightBarButton:nil];
    else
        [NAVIGATION setTitleWithBarButtonItems:@"ADD CARD" forViewController:self showLeftBarButton:@"icon_back.png" showRightBarButton:nil];
    
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.tableFooterView = [UIView new];
    
    myComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    [HELPER roundCornerForView:self.tableView radius:5 borderColor:[UIColor blackColor]];
    
    if (_aDictionary) {
        
        _myCardExpireDate = [_aDictionary valueForKey:@"Expiry_Date"];
        
        NSDateFormatter *aDateFormate = [[NSDateFormatter alloc] init];
        [aDateFormate setDateFormat: XML_POST_DATE_FORMATE];
        NSDate *adate = [aDateFormate dateFromString:_myCardExpireDate];
        
        myComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear fromDate:adate];
        
        self.cardExpiryDate = [NSString stringWithFormat:@"%ld, %ld", (long)myComponents.month, (long)myComponents.year];
        _cardNumber = [_aDictionary valueForKey:@"Credit_Card_Number"];
        _cardCVV = [_aDictionary valueForKey:@"CVN"];
        _cardHolderName = [_aDictionary valueForKey:@"Card_Holder_Name"];
        
        [_tableView reloadDataWithAnimation];
    }
    else {
        
        myComponents = [[[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian] components:NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        self.cardExpiryDate = [NSString stringWithFormat:@"%ld, %ld", (long)myComponents.month, (long)myComponents.year];
        _myCardExpireDate = [HELPER getConvertedDateFormatFrom:nil to:XML_POST_DATE_FORMATE forDate:[self firstDateOfYear]];
    }
}

- (NSDate *)firstDateOfYear {
    
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    dc.year = dc.year;
    dc.month = dc.month;
    dc.day = 01;
    return [[NSCalendar currentCalendar] dateFromComponents:dc];
}

- (BOOL)enableSubmitButtonIfValidationSuccess {
    
    BOOL isValid = YES;
    
    if ([self.cardNumber length] == 0) {
        
        isValid = NO;
        
        [HELPER showAlertView:self title:SCREEN_TITLE_ADD_CARD message:@"Please enter the card number" okButtonBlock:^(UIAlertAction *action) {
            
            [[self.tableView viewWithTag:1] becomeFirstResponder];
        }];
    }
    
    else if (self.cardNumber.length < 12) {
        
        isValid = NO;
        
        [HELPER showAlertView:self title:SCREEN_TITLE_ADD_CARD message:@"Please enter a valid card number" okButtonBlock:^(UIAlertAction *action) {
            
            [[self.tableView viewWithTag:1] becomeFirstResponder];
        }];
    }
    else if ([self.cardHolderName length] == 0) {
        
        isValid = NO;
        
        [HELPER showAlertView:self title:SCREEN_TITLE_ADD_CARD message:@"Please enter the name on card" okButtonBlock:^(UIAlertAction *action) {
            
            [[self.tableView viewWithTag:2] becomeFirstResponder];
        }];
    }
    else if ([self.cardExpiryDate length] == 0) {
        
        isValid = NO;
        
        [HELPER showAlertView:self title:SCREEN_TITLE_ADD_CARD message:@"Please enter a valid expiry card" okButtonBlock:^(UIAlertAction *action) {
            
            [[self.tableView viewWithTag:3] becomeFirstResponder];
        }];
    }
    else if ([self.cardCVV length] == 0) {
        
        isValid = NO;
        
        [HELPER showAlertView:self title:SCREEN_TITLE_ADD_CARD message:@"Please enter a CVV" okButtonBlock:^(UIAlertAction *action) {
            
            [[self.tableView viewWithTag:4] becomeFirstResponder];
        }];
    }
    return isValid;
}

- (void)leftBarButtonTapEvent {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonTapEvent {
    
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (IBAction)submitButtonTapEvent:(id)sender {
    
    if ([self enableSubmitButtonIfValidationSuccess]) {
        
        [self callWebService];
    }
    
}

- (void)expireDateValueChanged:(NTMonthYearPicker *)sender {
    
    BKCardExpiryField *textField = (BKCardExpiryField *)[self.tableView viewWithTag:3];
    
    myComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[sender date]];
    textField.dateComponents = myComponents;
    
    self.cardExpiryDate = [NSString stringWithFormat:@"%ld, %ld", (long)myComponents.month, (long)myComponents.year];
    
    if ((long)myComponents.month >= 10) {
        
        _myCardExpireDate = [NSString stringWithFormat:@"0%d/%ld/%ld", 1,(long)myComponents.month, (long)myComponents.year];
    }
    else {
        
        _myCardExpireDate = [NSString stringWithFormat:@"0%d/0%ld/%ld", 1,(long)myComponents.month, (long)myComponents.year];
    }
}


+ (CGFloat)toolbarHeight {
    
    return 44.f;
}

- (void)expiryNextButtonTapped{
    
    BKCardExpiryField *textField = (BKCardExpiryField *)[self.tableView viewWithTag:3];
    textField.dateComponents = myComponents;
    
    self.cardExpiryDate = [NSString stringWithFormat:@"%ld, %ld", (long)myComponents.month, (long)myComponents.year];
    
    if ((long)myComponents.month >= 10) {
        
        _myCardExpireDate = [NSString stringWithFormat:@"0%d/%ld/%ld", 1,(long)myComponents.month, (long)myComponents.year];
    }
    else {
        
        _myCardExpireDate = [NSString stringWithFormat:@"0%d/0%ld/%ld", 1,(long)myComponents.month, (long)myComponents.year];
    }
    
    // Focus CVV Field
    [[self.tableView viewWithTag:4] becomeFirstResponder];
}


- (void)cvvNextButtonTapped {
    
    UITextField *aTextfield = (UITextField *)[_tableView viewWithTag:4];
    _cardCVV = aTextfield.text;
    
    [aTextfield resignFirstResponder];
}

- (void)cardNumberNextButtonTapped {
    
    BKCardNumberField *aTextfield = (BKCardNumberField *)[_tableView viewWithTag:1];
    _cardNumber = aTextfield.text;
    
    // Focus Card name field
    [[self.tableView viewWithTag:2] becomeFirstResponder];
}

// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)callWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_ADD_CARD;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callWebService];
            }
        }];
        return;
    }
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aLoginMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aMutableDict[@"Credit_Card_Number"] = [_cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    aMutableDict[@"CVN"] = _cardCVV;
    aMutableDict[@"Expiry_Date"] = [HELPER getConvertedDateFormatFrom:XML_POST_DATE_FORMATE to:WEB_DATE_FORMAT forDateTime:_myCardExpireDate];
    aMutableDict[K_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    aMutableDict[@"Card_Holder_Name"] = _cardHolderName;
    aMutableDict[@"Card_Id"] = [_aDictionary valueForKey:@"Card_Id"];
    
    aLoginMutableDict[@"Card_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER saveCardDetails:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            aMutableArray = [response valueForKey:@"Card_Info"];
            
            [SESSION setCardInfo:aMutableArray];
            
            [HELPER showAlertView:self title:SCREEN_TITLE_ADD_CARD message:response[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                
                if (_isFromOTPScreen) {
                    [HELPER navigateToMenuDetailScreen];
                }
                else
                    [self leftBarButtonTapEvent];
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
                    [self callWebService];
                }
            }];
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        
        [HELPER removeLoadingIn:self];
    }];
    
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    BKCardExpiryField *textField = (BKCardExpiryField *)[self.tableView viewWithTag:3];
    
    self.cardExpiryDate = [NSString stringWithFormat:@"%lu, %lu", (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear];
    
    NSArray *array = [self.cardExpiryDate componentsSeparatedByString:@", "];
    
    if ([array count] != 0) {
        
        NSDateComponents *dateComp = [NSDateComponents new];
        dateComp.month = [array[0] integerValue];
        dateComp.year = [array[1] integerValue];
        textField.dateComponents = dateComp;
        
        // self.cardNumber = info.cardNumber;
        // self.cardCVV = info.cvv;
    }
    
    [self.tableView reloadData];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  WTAddressBookViewController.m
//  sandbox
//
//  Created by Wito Chandra on 7/11/14.
//  Copyright (c) 2014 Wito Chandra. All rights reserved.
//

#import "WTAddressBookViewController.h"

#import <AddressBookUI/AddressBookUI.h>

@interface WTAddressBookViewController () <ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) ABPeoplePickerNavigationController *peoplePickerController;

@end

@implementation WTAddressBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions
- (IBAction)buttonShowPickerPressed:(id)sender
{
    if (!_peoplePickerController) {
        _peoplePickerController = [ABPeoplePickerNavigationController new];
        _peoplePickerController.peoplePickerDelegate = self;
    }
    [self presentViewController:_peoplePickerController animated:true completion:NULL];
}

- (IBAction)buttonDumpPeoplePressed:(id)sender {
    CFErrorRef *error;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);

    for(int i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );

        NSString *firstName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        printf("\r\nName: %s %s", [firstName cStringUsingEncoding:NSUTF8StringEncoding], [lastName cStringUsingEncoding:NSUTF8StringEncoding]);

        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);

        for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
            NSString *email = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(emails, i);
            printf("\r\nemail: %s", [email cStringUsingEncoding:NSUTF8StringEncoding]);
        }

        printf("\r\n=============================================");
    }
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:true completion:NULL];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSString *firstName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *email = @"";
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i = 0; i < ABMultiValueGetCount(emails); i++) {
        // NSString *label = (__bridge_transfer NSString *)(ABMultiValueCopyLabelAtIndex(emails, i));
        NSString *temp = (__bridge_transfer NSString *)(ABMultiValueCopyValueAtIndex(emails, i));
        if (email.length > 0) email = [email stringByAppendingString:@"\n"];
        email = [email stringByAppendingString:temp];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Person" message:[NSString stringWithFormat:@"First name = %@\r\nEmail = %@", firstName, email] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Select", NULL];
    [alertView show];
    return false;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return false;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Select"]) {
        [self dismissViewControllerAnimated:true completion:NULL];
    }
}

@end

//
//  HLSaveLoadColorsView.m
//  HomeLed
//
//  Created by Pavel Molodkin on 12.08.15.
//  Copyright © 2015 Voevoda's Incorporated. All rights reserved.
//

#import "HLSaveLoadColorsView.h"
#import "HLLoadColorsViewController.h"
#import "HLGeneralPaintViewController.h"

@interface HLSaveLoadColorsView ()

@property(strong, nonatomic) NSString *nameAssemblyColors;
@property(strong, nonatomic) IBOutlet UIButton *saveButton;
@property(strong, nonatomic) IBOutlet UIButton *loadButton;

@end

@implementation HLSaveLoadColorsView

- (void)awakeFromNib
{
    _saveButton.layer.cornerRadius = 5.f;
    _loadButton.layer.cornerRadius = 5.f;
}

- (void)layoutSubviews { [super layoutSubviews]; }

- (IBAction)saveButtonTapped:(id)sender
{
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"Сохранить сборку цветов"
                                            message:@"Введите название сборки"
                                     preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Name", @"NamePlaceholder");
        [textField addTarget:self
                      action:@selector(alertTextFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   NSMutableArray *savedColorsArray =
                                       [[HLSettings shared].savedColorsArray mutableCopy];
                                   if (_nameAssemblyColors && [HLSettings shared].multiColorsList) {
                                       NSDictionary *descriptionDictionary = @{
                                           @"name" : _nameAssemblyColors,
                                           @"colorsArray" : [HLSettings shared].multiColorsList
                                       };
                                       [savedColorsArray insertObject:descriptionDictionary atIndex:0];
                                       [HLSettings shared].savedColorsArray = [savedColorsArray copy];
                                   }
                               }];

    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", @"Close action")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {}];
    [alertController addAction:okAction];
    [alertController addAction:closeAction];
    okAction.enabled = NO;
    [_viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)_viewController.presentedViewController;
    if (alertController) {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = login.text.length > 0;
        _nameAssemblyColors = alertController.textFields.firstObject.text;
    }
}

- (IBAction)loadButtonTapped:(id)sender
{
    __weak typeof(self) wself = self;
    [HLLoadColorsViewController presentLoadColorsWithCompletionBlock:^(BOOL finished) {
        if (wself.completionBlock) {
            wself.completionBlock(finished);
        }
    }];
}

@end

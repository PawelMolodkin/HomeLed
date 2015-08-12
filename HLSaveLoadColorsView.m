//
//  HLSaveLoadColorsView.m
//  HomeLed
//
//  Created by Pavel Molodkin on 12.08.15.
//  Copyright © 2015 Voevoda's Incorporated. All rights reserved.
//

#import "HLSaveLoadColorsView.h"

@interface HLSaveLoadColorsView ()

@property(strong,nonatomic) NSString *nameAssemblyColors;

@end

@implementation HLSaveLoadColorsView

- (id)init {
    self = [super init];
    UIButton *saveButton = [UIButton new];
    UIColor *buttonColor = [UIColor colorWithRed:(239/255.0) green:(239/255.0) blue:(239/255.0) alpha:1] ;
    saveButton.backgroundColor = buttonColor;
    [saveButton setTitle:@"Сохранить" forState:UIControlStateNormal];
    saveButton.layer.cornerRadius = 3.f;
    [saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:saveButton];
    UIButton *loadButton = [UIButton new];
    loadButton.backgroundColor = buttonColor ;
    [loadButton setTitle:@"Загрузить" forState:UIControlStateNormal];
    loadButton.layer.cornerRadius = 3.f;
    [loadButton addTarget:self action:@selector(loadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [loadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:loadButton];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutSaveButton];
    [self layoutLoadButton];
}

- (void)layoutSaveButton {
    UIButton *button = self.subviews.firstObject;
    CGRect frame = self.bounds;
    frame.origin = CGPointMake(3.f, 3.f);
    frame.size.height -= 6.f;
    frame.size.width = self.width / 2 - 5.f;
    button.frame = frame;
}

- (void)layoutLoadButton {
    UIButton *button = self.subviews.lastObject;
    CGRect frame = self.bounds;
    frame.origin = CGPointMake(3.f, 3.f);
    frame.size.height -= 6.f;
    frame.size.width = self.width / 2 - 5.f;
    frame.origin.x = self.width / 2;
    button.frame = frame;
}

- (void)saveButtonTapped {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Сохранить сборку цветов"
                                          message:@"Введите название сборки"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Name", @"NamePlaceholder");
         [textField addTarget:self
                       action:@selector(alertTextFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
     }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSMutableArray *savedColorsArray = [NSMutableArray new];
                                   if (![HLSettings shared].savedColorsArray) {
                                       savedColorsArray = [@[] mutableCopy];
                                   } else {
                                       savedColorsArray = [[HLSettings shared].savedColorsArray mutableCopy];
                                   }
                                   NSMutableArray *multiColorArray = [[HLSettings shared].multiColorsList mutableCopy];
                                   NSDictionary *saveColorsDictionary = [NSDictionary dictionaryWithObject:multiColorArray forKey:_nameAssemblyColors];
                                   [savedColorsArray addObject:saveColorsDictionary];
                                   [HLSettings shared].savedColorsArray = [savedColorsArray copy];
                                    }];
    
    UIAlertAction *closeAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Close", @"Close action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {}];

    [alertController addAction:okAction];
    [alertController addAction:closeAction];
    okAction.enabled = NO;
    [_viewController presentViewController:alertController animated:YES
                     completion:nil];
    
}

- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)_viewController.presentedViewController;
    if (alertController)
    {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = login.text.length > 0;
        _nameAssemblyColors = alertController.textFields.firstObject.text;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

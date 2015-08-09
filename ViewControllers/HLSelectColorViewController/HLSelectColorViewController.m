//
//  HLSelectColorViewController.m
//  HomeLed
//
//  Created by ANDREI VAYAVODA on 07.08.15.
//  Copyright (c) 2015 Voevoda's Incorporated. All rights reserved.
//

#import "HLGeneralPaintViewController.h"
#import "HLSelectColorViewController.h"
#import "HLColorPicker.h"

@interface HLSelectColorViewController ()
@property (strong, nonatomic) void (^completionBlock)(UIColor *color, BOOL finished);
@property (strong, nonatomic) IBOutlet HLColorPicker *colorPicker;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) IBOutlet UIButton *finishButton;
@end

@implementation HLSelectColorViewController

#pragma mark - Initialization
+ (void)presentWithColor:(UIColor *)color completion:(void(^)(UIColor *color, BOOL finished))completionBlock {
    HLSelectColorViewController *viewController = [[HLSelectColorViewController alloc] initWithNibName:@"HLSelectColorViewController" bundle:nil];
    viewController.completionBlock = completionBlock;
    viewController.color = color;
    [[HLGeneralPaintViewController shared] presentViewController:viewController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _colorPicker = [[NSBundle mainBundle] loadNibNamed:@"HLColorPicker" owner:self options:nil].firstObject;
    [self.view addSubview:_colorPicker];
    __weak typeof (self) wself = self;
    _colorPicker.didChangeColorBlock = ^(UIColor *color) {
        wself.color = color;
        if (wself.completionBlock) {
            wself.completionBlock(color, NO);
        }
    };
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)finishButtonTapped:(id)sender {
    __weak typeof (self) wself = self;
    [[HLGeneralPaintViewController shared] dismissViewControllerAnimated:YES completion:^{
        if (wself.completionBlock) {
            wself.completionBlock(wself.color, YES);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutColorPicker];
    [self layoutFinishButton];
}

- (void)layoutColorPicker {
    CGRect frame = self.view.bounds;
    frame.origin.y = 20.f;
    frame.size.height = [_colorPicker desiredHeight];
    _colorPicker.frame = frame;
}

- (void)layoutFinishButton {
    CGRect frame = _finishButton.frame;
    frame.origin.y = _colorPicker.y + _colorPicker.height + 20.f;
    frame.origin.x = self.view.width / 2 - _finishButton.width / 2;
    _finishButton.frame = frame;
}

#pragma mark - Accessors
- (void)setColor:(UIColor *)color {
    _color = color;
    if (![self.colorPicker.colorPicker.color isEqual:color]) {
        [self view];
        self.colorPicker.colorPicker.color = color;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  HLColorLineView.m
//  HomeLed
//
//  Created by Pavel Molodkin on 14.08.15.
//  Copyright © 2015 Voevoda's Incorporated. All rights reserved.
//

#import "HLColorLineView.h"
#import "HLSelectColorViewController.h"

@interface HLColorLineView ()

- (id)initWithColor:(UIColor *)color didChangeColorBlock:(void (^)(UIColor *color, BOOL finished))didChangeColorBlock;

@property(nonatomic, copy) void (^didChangeColorBlock)(UIColor *color, BOOL finished);
@property(strong, nonatomic) IBOutlet UIButton *colorButton;
@property(strong, nonatomic) IBOutlet UIButton *removeColorButton;

@end

@implementation HLColorLineView

- (id)initWithColor:(UIColor *)color didChangeColorBlock:(void (^)(UIColor *color, BOOL finished))didChangeColorBlock
{
    if (self = [super init]) {
        HLColorLineView *colorLineView =
            (HLColorLineView *)
            [[NSBundle mainBundle] loadNibNamed:@"HLColorLineView" owner:self options:nil].firstObject;
        self = colorLineView;
        self.didChangeColorBlock = didChangeColorBlock;
        _colorButton.backgroundColor = color;
        _colorButton.layer.cornerRadius = 3.f;
    }
    return self;
}

- (void)layoutSubviews { [super layoutSubviews]; }

- (IBAction)colorButtonTapped:(id)sender
{
    UIButton *colorButton = self.subviews.firstObject;
    __weak typeof(self) wself = self;
    [HLSelectColorViewController presentWithColor:colorButton.backgroundColor
                                       completion:^(UIColor *color, BOOL finished) {
                                           colorButton.backgroundColor = color;
                                           if (wself.didChangeColorBlock) {
                                               wself.didChangeColorBlock(color, finished);
                                           }
                                       }];
}

- (IBAction)removeButtonTapped:(id)sender
{
    if (self.didChangeColorBlock) {
        self.didChangeColorBlock(nil, YES);
    }
}

@end

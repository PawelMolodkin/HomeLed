//
//  HLAnimationOptionsCell.m
//  HomeLed
//
//  Created by Pavel Molodkin on 28.08.15.
//  Copyright © 2015 Voevoda's Incorporated. All rights reserved.
//

#import "HLColorsAnimationViewController.h"
#import "HLGeneralPaintViewController.h"
#import "HLAnimationOptionsCell.h"
#import "HLSlider.h"

static CGFloat kXOffset = 10.f;
static CGFloat kYOffset = 10.f;
static CGFloat kHeightCell = 40.f;
static CGFloat kSliderRange = 10.f;

@interface HLAnimationOptionsCell ()

@property(strong, nonatomic) IBOutlet UILabel *titleLabel;
@property(strong, nonatomic) IBOutlet UILabel *disabledAnimationLabel;
@property(strong, nonatomic) IBOutlet UISwitch *switchSettingsAnimation;
@property(strong, nonatomic) IBOutlet UILabel *speedAnimationLabel;
@property(strong, nonatomic) IBOutlet HLSlider *animationSpeedSlider;
@property(strong, nonatomic) IBOutlet UILabel *valueSpeedLabel;
@property(strong, nonatomic) IBOutlet UIView *view;
@property(strong, nonatomic) IBOutlet UIButton *colorsAnimationButton;

@end

@implementation HLAnimationOptionsCell

#pragma mark - Initialization

- (void)awakeFromNib
{
    _colorsAnimationButton.layer.cornerRadius = 10.f;
    self.animationSpeedSlider.bottomValueSlider = 100.f;
    __weak typeof(self) wself = self;
    _animationSpeedSlider.valueChangedBlock = ^{ [wself sliderValueChanged:wself.animationSpeedSlider.value]; };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)expandedHeight
{
    return _titleLabel.height + _switchSettingsAnimation.height + _speedAnimationLabel.height +
           _animationSpeedSlider.height + _valueSpeedLabel.height + _colorsAnimationButton.height + kYOffset * 4;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self titleLabelLayout];
    [self disabledAnimationLabelLayout];
    [self switchSettingsAnimationLayout];
    [self speedAnimationLabelLayout];
    [self animationSpeedSliderLayout];
    [self valueSpeedLabelLayout];
    [self clorosAnimationButtonLayout];
}

- (void)titleLabelLayout
{
    CGRect frame = self.titleLabel.frame;
    frame.size.width = self.bounds.size.width;
    frame.size.height = kHeightCell;
    frame.origin.x = 0.f;
    frame.origin.y = 0.f;
    self.titleLabel.frame = frame;
}

- (void)disabledAnimationLabelLayout
{
    CGRect frame = self.disabledAnimationLabel.frame;
    frame.size.width = self.bounds.size.width - _switchSettingsAnimation.width;
    frame.origin.x = 2 * kXOffset;
    frame.origin.y = _titleLabel.height + kYOffset;
    self.disabledAnimationLabel.frame = frame;
}

- (void)switchSettingsAnimationLayout
{
    CGRect frame = self.switchSettingsAnimation.frame;
    frame.origin.x = self.bounds.size.width - kXOffset - _switchSettingsAnimation.width;
    frame.origin.y = _titleLabel.height + kYOffset;
    self.switchSettingsAnimation.frame = frame;
}

- (void)speedAnimationLabelLayout
{
    CGRect frame = self.speedAnimationLabel.frame;
    frame.origin.x = (self.bounds.size.width - kXOffset - _speedAnimationLabel.width) / 2;
    frame.origin.y = _titleLabel.height + _switchSettingsAnimation.height + kYOffset;
    self.speedAnimationLabel.frame = frame;
}

- (void)animationSpeedSliderLayout
{
    CGRect frame = self.animationSpeedSlider.frame;
    frame.size.width = self.bounds.size.width - 3 * kXOffset;
    frame.origin.x = kXOffset;
    frame.origin.y = _titleLabel.height + _switchSettingsAnimation.height + _speedAnimationLabel.height + kYOffset;
    self.animationSpeedSlider.frame = frame;
}

- (void)valueSpeedLabelLayout
{
    CGRect frame = self.valueSpeedLabel.frame;
    frame.size.width = self.bounds.size.width / 2;
    frame.origin.x = (self.bounds.size.width - frame.size.width) / 2;
    frame.origin.y = _titleLabel.height + _switchSettingsAnimation.height + _speedAnimationLabel.height +
                     _valueSpeedLabel.height + kYOffset;
    self.valueSpeedLabel.frame = frame;
}

- (void)clorosAnimationButtonLayout
{
    CGRect frame = self.colorsAnimationButton.frame;
    frame.size.width = self.bounds.size.width / 2 + kXOffset * 2;
    frame.origin.x = (self.bounds.size.width - frame.size.width) / 2;
    frame.origin.y = _titleLabel.height + _switchSettingsAnimation.height + _speedAnimationLabel.height +
                     _valueSpeedLabel.height + kYOffset * 2 + _speedAnimationLabel.height;
    self.colorsAnimationButton.frame = frame;
}

- (void)setExpandedMode:(BOOL)expandedMode
{
    [super setExpandedMode:expandedMode];
    _disabledAnimationLabel.hidden = !expandedMode;
    _switchSettingsAnimation.hidden = !expandedMode;
    _speedAnimationLabel.hidden = !expandedMode;
    _animationSpeedSlider.hidden = !expandedMode;
    _valueSpeedLabel.hidden = !expandedMode;
    _colorsAnimationButton.hidden = !expandedMode;
    if (expandedMode) {
        _animationSpeedSlider.value = [HLSettings shared].speedAnimation;
        [self sliderValueChanged:_animationSpeedSlider.value];
        _switchSettingsAnimation.on = [HLSettings shared].animationEnabled;
        _titleLabel.backgroundColor =
            [UIColor colorWithRed:239.f / 255.f green:239.f / 255.f blue:239.f / 255.f alpha:0.5];
    } else {
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
}

- (void)sliderValueChanged:(CGFloat)value
{
    CGFloat sliderValue = kSliderRange * _animationSpeedSlider.value;
    float rounded = sliderValue < 0.1f ? 0.1f : floorf(sliderValue * 10) / 10;
    _valueSpeedLabel.text = [@(rounded) stringValue];
    [HLSettings shared].speedAnimation = value;
}
- (IBAction)actionSwitchSettingsAnimation:(BOOL)isOn
{
    [HLSettings shared].animationEnabled = _switchSettingsAnimation.isOn;
}
- (IBAction)tappedColorsAnimationButton:(id)sender { [HLColorsAnimationViewController presentColorsAnimation]; }

@end

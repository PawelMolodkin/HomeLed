//
//  HLMultiColorsCell.m
//  HomeLed
//
//  Created by ANDREI VAYAVODA on 07.08.15.
//  Copyright (c) 2015 Voevoda's Incorporated. All rights reserved.
//

#import "HLSelectColorViewController.h"
#import "HLColorLineView.h"
#import "HLSaveLoadColorsView.h"
#import "HLMultiColorsCell.h"
#import "HLRemoteClient.h"

static CGFloat kColorLineHeight = 40.f;

@interface HLMultiColorsCell ()

@property(strong, nonatomic) IBOutlet UILabel *titleLabel;
@property(strong, nonatomic) UIView *colorsListContentView;
@property(strong, nonatomic) NSArray *colorsArray;
@property(strong, nonatomic) IBOutlet UIButton *addColorButton;

@end

@implementation HLMultiColorsCell

#pragma mark - Initialization

- (void)awakeFromNib { [super awakeFromNib]; }

- (void)initialize
{
    _colorsListContentView.hidden = YES;
    _addColorButton.hidden = YES;
    self.colorsArray = [HLSettings shared].multiColorsList;
}

#pragma mark - Overriden
- (CGFloat)expandedHeight
{
    return _titleLabel.height + _colorsArray.count * kColorLineHeight + _addColorButton.height + kColorLineHeight;
}

- (void)setExpandedMode:(BOOL)expandedMode
{
    [super setExpandedMode:expandedMode];
    _colorsListContentView.hidden = !expandedMode;
    _addColorButton.hidden = !expandedMode;
    if (expandedMode) {
        [HLRemoteClient setColorsList:[HLSettings shared].multiColorsList];
    }
}

#pragma mark - UIView
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutTitleLabel];
    [self layoutColorsListContentView];
    [self layoutColorsListContentViewSubviews];
    [self layoutAddColorButton];
}

- (void)layoutTitleLabel
{
    CGRect frame = self.bounds;
    frame.origin.x = 10.f;
    frame.size.height = 44.f;
    _titleLabel.frame = frame;
}

- (void)layoutColorsListContentView
{
    CGRect frame = self.bounds;
    frame.origin.y = _titleLabel.y + _titleLabel.height;
    frame.size.height = _colorsArray.count * kColorLineHeight + kColorLineHeight;
    frame.origin.x = 10.f;
    frame.size.width -= 20.f;
    _colorsListContentView.frame = frame;
}

- (void)layoutColorsListContentViewSubviews
{
    CGRect frame = _colorsListContentView.bounds;
    frame.size.height = kColorLineHeight;
    for (UIView *subview in _colorsListContentView.subviews) {
        subview.frame = frame;
        frame.origin.y += kColorLineHeight;
    }
}

- (void)layoutAddColorButton
{
    CGRect frame = _addColorButton.frame;
    frame.size.width = self.width;
    frame.origin.x = 0.f;
    frame.origin.y = _colorsListContentView.y + _colorsListContentView.height;
    _addColorButton.frame = frame;
}

#pragma mark - Accessors
- (void)setColorsArray:(NSArray *)colorsArray
{
    if (_colorsArray && _colorsArray != colorsArray) {
        [HLRemoteClient setColorsList:colorsArray];
    }
    _colorsArray = colorsArray;
    [HLSettings shared].multiColorsList = _colorsArray;
    [self resetColorsListContentView];
}

#pragma mark - Private
- (void)resetColorsListContentView
{
    [_colorsListContentView removeFromSuperview];
    _colorsListContentView = [UIView new];
    [self.contentView addSubview:_colorsListContentView];
    __weak typeof(self) wself = self;
    HLSaveLoadColorsView *saveLoadView =
        (HLSaveLoadColorsView *)
        [[NSBundle mainBundle] loadNibNamed:@"HLSaveLoadColorsView" owner:self options:nil].firstObject;
    saveLoadView.completionBlock = ^void(BOOL finished) {
        wself.colorsArray = [HLSettings shared].multiColorsList;
        UITableView *tableView = (UITableView *)wself.superview.superview;
        [tableView reloadData];
    };
    saveLoadView.viewController = _viewController;
    [_colorsListContentView addSubview:saveLoadView];
    NSInteger counter = 0;

    for (UIColor *color in _colorsArray) {
        HLColorLineView *colorLineView =
            [[HLColorLineView alloc] initWithColor:color
                               didChangeColorBlock:^(UIColor *color, BOOL finished) {
                                   NSMutableArray *array = [wself.colorsArray mutableCopy];
                                   if (color) {
                                       [array replaceObjectAtIndex:counter withObject:color];
                                   } else {
                                       [array removeObjectAtIndex:counter];
                                   }
                                   if (finished) {
                                       wself.colorsArray = array;
                                   } else {
                                       [HLRemoteClient setColorsList:array];
                                   }
                               }];
        ++counter;
        [_colorsListContentView addSubview:colorLineView];
    }
    _colorsListContentView.hidden = !self.expandedMode;
    [self setNeedsLayout];
}

#pragma mark - Observers
- (IBAction)addColorButtonTapped:(id)sender
{
    __weak typeof(self) wself = self;
    [HLSelectColorViewController presentWithColor:[UIColor whiteColor]
                                       completion:^(UIColor *color, BOOL finished) {
                                           if (finished) {
                                               NSMutableArray *array = [wself.colorsArray mutableCopy];
                                               [array addObject:color];
                                               wself.colorsArray = array;
                                               UITableView *tableView = (UITableView *)wself.superview.superview;
                                               [tableView reloadData];
                                           }
                                       }];
}

@end

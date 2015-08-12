//
//  HLMultiColorsCell.m
//  HomeLed
//
//  Created by ANDREI VAYAVODA on 07.08.15.
//  Copyright (c) 2015 Voevoda's Incorporated. All rights reserved.
//

#import "HLSelectColorViewController.h"
#import "HLMultiColorsCell.h"
#import "HLSaveLoadColorsView.h"
#import "HLRemoteClient.h"

static CGFloat kColorLineHeight = 40.f;

@interface HLColorLineView : UIView
- (id)initWithColor:(UIColor *)color didChangeColorBlock:(void(^)(UIColor *color, BOOL finished))didChangeColorBlock;
@property (nonatomic, copy) void(^didChangeColorBlock)(UIColor *color, BOOL finished);
@end

@implementation HLColorLineView

- (id)initWithColor:(UIColor *)color didChangeColorBlock:(void(^)(UIColor *color, BOOL finished))didChangeColorBlock {
    if (self = [super init]) {
        self.didChangeColorBlock = didChangeColorBlock;
        UIButton *colorButton = [UIButton new];
        colorButton.backgroundColor = color;
        colorButton.layer.cornerRadius = 3.f;
        [colorButton addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:colorButton];
        UIButton *removeColorButton = [UIButton new];
        [removeColorButton setTitle:@"Удалить" forState:UIControlStateNormal];
        [removeColorButton addTarget:self action:@selector(removeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [removeColorButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:removeColorButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutColorView];
    [self layoutRemoveColorButton];
}

- (void)layoutColorView {
    UIButton *colorButton = self.subviews.firstObject;
    CGRect frame = self.bounds;
    frame.origin = CGPointMake(3.f, 3.f);
    frame.size.height -= 6.f;
    frame.size.width = 120.f;
    colorButton.frame = frame;
}

- (void)layoutRemoveColorButton {
    UIButton *button = self.subviews.lastObject;
    CGRect frame = self.bounds;
    CGRect labelRect = [button.titleLabel.text boundingRectWithSize:self.size
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{ NSFontAttributeName : button.titleLabel.font }
                                                            context:nil];
    
    frame.size.width = labelRect.size.width;
    frame.origin.x = self.width - frame.size.width;
    button.frame = frame;
}

- (void)colorButtonTapped:(UIButton *)button {
    UIButton *colorButton = self.subviews.firstObject;
    __weak typeof (self) wself = self;
    [HLSelectColorViewController presentWithColor:colorButton.backgroundColor completion:^(UIColor *color, BOOL finished) {
        colorButton.backgroundColor = color;
        if (wself.didChangeColorBlock) {
            wself.didChangeColorBlock(color, finished);
        }
    }];
}

- (void)removeButtonTapped:(UIButton *)button {
    if (self.didChangeColorBlock) {
        self.didChangeColorBlock(nil, YES);
    }
}

@end

@interface HLMultiColorsCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UIView *colorsListContentView;
@property (strong, nonatomic) NSArray *colorsArray;
@property (strong, nonatomic) IBOutlet UIButton *addColorButton;

@end

@implementation HLMultiColorsCell

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)initialize {
    _colorsListContentView.hidden = YES;
    _addColorButton.hidden = YES;
    self.colorsArray = [HLSettings shared].multiColorsList;
}

#pragma mark - Overriden
- (CGFloat)expandedHeight {
    return _titleLabel.height + _colorsArray.count * kColorLineHeight + _addColorButton.height;
}

- (void)setExpandedMode:(BOOL)expandedMode {
    [super setExpandedMode:expandedMode];
    _colorsListContentView.hidden = !expandedMode;
    _addColorButton.hidden = !expandedMode;
    if (expandedMode) {
        [HLRemoteClient setColorsList:[HLSettings shared].multiColorsList];
    }
}

#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutTitleLabel];
    [self layoutColorsListContentView];
    [self layoutColorsListContentViewSubviews];
    [self layoutAddColorButton];
}

- (void)layoutTitleLabel {
    CGRect frame = self.bounds;
    frame.origin.x = 10.f;
    frame.size.height = 44.f;
    _titleLabel.frame = frame;
}

- (void)layoutColorsListContentView {
    CGRect frame = self.bounds;
    frame.origin.y = _titleLabel.y + _titleLabel.height;
    frame.size.height = _colorsArray.count * kColorLineHeight;
    frame.origin.x = 10.f;
    frame.size.width -= 20.f;
    _colorsListContentView.frame = frame;
}

- (void)layoutColorsListContentViewSubviews {
    CGRect frame = _colorsListContentView.bounds;
    frame.size.height = kColorLineHeight;
    for (UIView *subview in _colorsListContentView.subviews) {
        subview.frame = frame;
        frame.origin.y += kColorLineHeight;
    }
}

- (void)layoutAddColorButton {
    CGRect frame = _addColorButton.frame;
    frame.size.width = self.width;
    frame.origin.x = 0.f;
    frame.origin.y = _colorsListContentView.y + _colorsListContentView.height;
    _addColorButton.frame = frame;
}

#pragma mark - Accessors
- (void)setColorsArray:(NSArray *)colorsArray {
    if (_colorsArray && _colorsArray != colorsArray) {
        [HLRemoteClient setColorsList:colorsArray];
    }
    _colorsArray = colorsArray;
    [HLSettings shared].multiColorsList = _colorsArray;
    [self resetColorsListContentView];
}

#pragma mark - Private
- (void)resetColorsListContentView {
    [_colorsListContentView removeFromSuperview];
    _colorsListContentView = [UIView new];
    [self.contentView addSubview:_colorsListContentView];
    HLSaveLoadColorsView *saveLoadView = [[HLSaveLoadColorsView alloc] init];
    saveLoadView.viewController = _viewController;
    [_colorsListContentView addSubview:saveLoadView];
    NSInteger counter = 0;
    __weak typeof(self) wself = self;
    for (UIColor *color in _colorsArray) {
        HLColorLineView *colorLineView = [[HLColorLineView alloc] initWithColor:color didChangeColorBlock:^(UIColor *color, BOOL finished) {
            NSMutableArray *array = [wself.colorsArray mutableCopy];
            if (color) {
                [array replaceObjectAtIndex:counter withObject:color];
            }
            else {
                [array removeObjectAtIndex:counter];
            }
            if (finished) {
                wself.colorsArray = array;
            }
            else {
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
- (IBAction)addColorButtonTapped:(id)sender {
    __weak typeof (self) wself = self;
    [HLSelectColorViewController presentWithColor:[UIColor whiteColor] completion:^(UIColor *color, BOOL finished) {
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

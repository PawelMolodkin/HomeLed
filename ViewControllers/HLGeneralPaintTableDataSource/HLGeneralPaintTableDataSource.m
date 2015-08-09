//
//  HLGeneralPaintTableDataSource.m
//  HomeLed
//
//  Created by ANDREI VAYAVODA on 06.08.15.
//  Copyright (c) 2015 Voevoda's Incorporated. All rights reserved.
//

#import "HLGeneralPaintTableDataSource.h"
#import "HLNetworkAddressCell.h"
#import "HLChangeColorCell.h"
#import "HLMultiColorsCell.h"

@interface HLGeneralPaintTableDataSource () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HLGeneralPaintTableDataSource {
    HLNetworkAddressCell *_networkAddressCell;
    NSInteger _indexOfNetworkAddressCell;
    HLChangeColorCell *_changeColorCell;
    NSInteger _indexOfChangeColorCell;
    HLMultiColorsCell *_multiColorsCell;
    NSInteger _indexOfMultiColorsCell;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self resetIndexes];
    NSInteger numberOfCells = 0;
    _indexOfNetworkAddressCell = numberOfCells++;
    _indexOfChangeColorCell = numberOfCells++;
    _indexOfMultiColorsCell = numberOfCells++;
    return numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _indexOfNetworkAddressCell) {
        return [self networkAddressCell];
    }
    else if (indexPath.row == _indexOfChangeColorCell) {
        return [self changeColorCell];
    }
    else if (indexPath.row == _indexOfMultiColorsCell) {
        return [self multiColorsCell];
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLBaseCell *cell =(HLBaseCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell.expandedMode) {
        return cell.expandedHeight;
    }
    return 44.f;
}

#pragma mark - Cells Methods
- (HLNetworkAddressCell *)networkAddressCell {
    if (!_networkAddressCell) {
        _networkAddressCell = (HLNetworkAddressCell *)[[NSBundle mainBundle] loadNibNamed:@"HLNetworkAddressCell" owner:self options:nil].firstObject;
    }
    return _networkAddressCell;
}

- (HLChangeColorCell *)changeColorCell {
    if (!_changeColorCell) {
        _changeColorCell = (HLChangeColorCell *)[[NSBundle mainBundle] loadNibNamed:@"HLChangeColorCell" owner:self options:nil].firstObject;
    }
    return _changeColorCell;
}

- (HLMultiColorsCell *)multiColorsCell {
    if (!_multiColorsCell) {
        _multiColorsCell = (HLMultiColorsCell *)[[NSBundle mainBundle] loadNibNamed:@"HLMultiColorsCell" owner:self options:nil].firstObject;
    }
    return _multiColorsCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HLBaseCell *cell = (HLBaseCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell.disallowExpanding) {
        cell.expandedMode = !cell.expandedMode;
        [tableView reloadData];
    }
}

#pragma mark - Private Methods
- (void)resetIndexes {
    _indexOfNetworkAddressCell = NSNotFound;
    _indexOfChangeColorCell = NSNotFound;
}

@end

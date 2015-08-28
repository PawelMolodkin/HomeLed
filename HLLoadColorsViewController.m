//
//  HLLoadColorsViewController.m
//  HomeLed
//
//  Created by Pavel Molodkin on 13.08.15.
//  Copyright © 2015 Voevoda's Incorporated. All rights reserved.
//

#import "HLLoadColorsViewController.h"
#import "HLGeneralPaintViewController.h"

@interface HLLoadColorsViewController ()

@property(strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray *colorsArray;
@property(strong, nonatomic) IBOutlet UIButton *cancelButton;
@property(copy, nonatomic) void (^completionBlock)(BOOL finished);

@end

@implementation HLLoadColorsViewController

#pragma mark - Initialization

+ (void)presentLoadColorsWithCompletionBlock:(void (^)(BOOL finished))completionBlock
{
    HLLoadColorsViewController *viewController =
        [[HLLoadColorsViewController alloc] initWithNibName:@"HLLoadColorsViewController" bundle:nil];
    viewController.completionBlock = completionBlock;
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:viewController];
    [[HLGeneralPaintViewController shared] presentViewController:navigationController animated:YES completion:nil];
    viewController.navigationItem.rightBarButtonItem = viewController.editButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _colorsArray = [HLSettings shared].savedColorsArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self layoutCancelButton];
}

- (void)layoutCancelButton
{
    CGRect frame = _cancelButton.frame;
    frame.origin.y = self.tableView.height + _cancelButton.height + 44.f;
    frame.origin.x = self.view.width / 2 - _cancelButton.width / 2;
    _cancelButton.frame = frame;
}

- (IBAction)finishButtonTapped:(id)sender { [self dismissViewControllerAnimated:YES completion:nil]; }

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _colorsArray.count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"loadColorsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if (_colorsArray.count > indexPath.row) {
        if ([_colorsArray isKindOfClass:[NSArray class]]) {
            NSDictionary *colorsDictionary = [_colorsArray objectAtIndex:indexPath.row];
            if ([colorsDictionary isKindOfClass:[NSDictionary class]]) {
                cell.textLabel.text = colorsDictionary[@"name"];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *loadColorsArray = nil;
    NSDictionary *loadColorsDictionary = nil;
    if (_colorsArray.count > indexPath.row) {
        if ([_colorsArray isKindOfClass:[NSArray class]]) {
            loadColorsDictionary = [_colorsArray objectAtIndex:indexPath.row];
            if ([loadColorsDictionary isKindOfClass:[NSDictionary class]]) {
                loadColorsArray = loadColorsDictionary[@"colorsArray"];
                [HLSettings shared].multiColorsList = loadColorsArray;
                __weak typeof(self) wself = self;
                [[HLGeneralPaintViewController shared] dismissViewControllerAnimated:YES
                                                                          completion:^{
                                                                              if (wself.completionBlock) {
                                                                                  wself.completionBlock(YES);
                                                                              }
                                                                          }];
            }
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:YES];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // add code here for when you hit delete
        NSMutableArray *savedColorsArray = [_colorsArray mutableCopy];
        [savedColorsArray removeObjectAtIndex:indexPath.row];
        [HLSettings shared].savedColorsArray = [savedColorsArray copy];
        _colorsArray = [HLSettings shared].savedColorsArray;
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

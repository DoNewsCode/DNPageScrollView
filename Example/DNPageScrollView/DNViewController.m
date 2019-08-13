//
//  DNViewController.m
//  DNPageScrollView
//
//  Created by 540563689@qq.com on 09/10/2018.
//  Copyright (c) 2018 540563689@qq.com. All rights reserved.
//

#import "DNViewController.h"

#import "DNPageOneViewController.h"
#import "DNPageTwoViewController.h"
#import "DNPageThreeViewController.h"
#import "DNPageFourViewController.h"

static NSString *cellIdentifier = @"DNViewControllerCell";

@interface DNViewController ()
@property(nonatomic, strong) NSArray *pages;

@end

@implementation DNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createContent];
    
}

#pragma mark - Private Methods
- (void)createContent {
    
    self.pages = @[@"Page:Default",@"Page:Symmetry",@"Page:Tab",@"Page:TimeLine",];
    
}

#pragma mark - Public Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.textLabel.text = self.pages[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
         [self.navigationController pushViewController:[DNPageOneViewController new] animated:YES];
    } else if (indexPath.row == 1) {
        [self.navigationController pushViewController:[DNPageTwoViewController new] animated:YES];
    } else if (indexPath.row == 2) {
        [self.navigationController pushViewController:[DNPageThreeViewController new] animated:YES];
    } else if (indexPath.row == 3) {
        [self.navigationController pushViewController:[DNPageFourViewController new] animated:YES];
    }
   
}

- (void)eventButton1Click:(UIButton *)button {
    
    [self.navigationController pushViewController:[DNPageTwoViewController new] animated:YES];
}

- (void)eventButton2Click:(UIButton *)button {
    [self.navigationController pushViewController:[DNPageThreeViewController new] animated:YES];
}

- (void)eventButton3Click:(UIButton *)button {
    
    [self.navigationController pushViewController:[DNPageFourViewController new] animated:YES];
}

@end

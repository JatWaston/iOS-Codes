//
//  RootViewController.m
//  SearchDemo
//
//  Created by JatWaston on 15/4/29.
//  Copyright (c) 2015年 JatWaston. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate> {
    UISearchDisplayController *_searchDisplayController;
    UISearchBar *_searchBar;
    UITableView *_contentTableView;
    NSMutableArray *_contentArray;
    NSArray *_filterData;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Apple";
    
    _contentArray = [[NSMutableArray alloc] initWithObjects:@"iPhone",@"iPod",@"iPod touch",@"iPad",@"iPad mini",@"iMac",@"Mac Pro",@"MacBook Air",@"MacBook Pro", nil];
    
    _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    [self.view addSubview:_contentTableView];
    [self addSearchBar];
}

- (void)addSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    _searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"All",@"Device",@"Potable", nil]; 
    _contentTableView.tableHeaderView = _searchBar;
//    [_contentTableView.tableHeaderView addSubview:_searchBar];
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _contentTableView) {
        return [_contentArray count];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",_searchDisplayController.searchBar.text];
        _filterData =  [[NSArray alloc] initWithArray:[_contentArray filteredArrayUsingPredicate:predicate]];
        return _filterData.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    if (tableView == _contentTableView) {
        cell.textLabel.text = [_contentArray objectAtIndex:[indexPath row]];
    } else {
        cell.textLabel.text = [_filterData objectAtIndex:[indexPath row]];
    }
    return cell;

}

#pragma mark - UITableViewDelegate

#pragma mark - UISearchDisplayDelegate



@end


#import "ViewController.h"

@interface ViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

// DataSource
@property (nonatomic, strong) NSArray        *normalData;
@property (nonatomic, strong) NSMutableArray *searchedData;

@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    [self setupViews];
}

- (void)makeData
{
    self.normalData   = @[@"text1", @"text2", @"text3", @"text4", @"text5"];
    self.searchedData = [@[] mutableCopy];
}


/**
 *  ビューのセットアップ
 */
- (void)setupViews
{
    self.view.backgroundColor = UIColor.redColor;
    
    // SearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.searchBar.delegate = self;
    self.searchBar.showsScopeBar = YES;
    self.searchBar.showsSearchResultsButton = YES;
    self.searchBar.scopeButtonTitles = @[@"test", @"hoge", @"foga"];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar
                                                              contentsController:self];
    self.searchController.delegate                = self;
    self.searchController.searchResultsDelegate   = self;
    self.searchController.searchResultsDataSource = self;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.searchBar;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchController.searchResultsTableView]) {
        return self.searchedData.count;
    }
    else {
        return self.normalData.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = nil;
    if ([tableView isEqual:self.searchController.searchResultsTableView]) {
        num = self.searchedData[indexPath.row];
    }
    else {
        num = self.normalData[indexPath.row];
    }
    
    static NSString *const idenfitifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfitifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:idenfitifer];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell - %@", num];
    return cell;
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark - UISearchBarDelegate

- (void)filterContentForSearchText:(NSString *)searchString
                             scope:(NSString *)scope
{
    [self.searchedData removeAllObjects];
    
    for (NSString *label in self.normalData) {
        NSRange range = [label rangeOfString:searchString
                                     options:NSCaseInsensitiveSearch];
        if (range.length > 0) {
            [self.searchedData addObject:label];
        }
    }
    
    // NSLog(@"Current result - %@", self.searchedData);
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing");
    [self.searchController setActive:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange");
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark - UISearchDisplayControllerDelegate

// 検索が開始された時点で呼ばれる
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerWillBeginSearch");
}
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerDidBeginSearch");
}


// 検索が実行された際に呼ばれる
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"shouldReloadTableForSearchString");
    [self filterContentForSearchText:searchString
                               scope:[[self.searchController.searchBar scopeButtonTitles] objectAtIndex:[self.searchController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerWillEndSearch");
}

@end


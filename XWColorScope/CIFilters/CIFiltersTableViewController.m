//
//  CIFiltersTableViewController.m
//  XWColorScope
//
//  Created by vivi wu on 2019/6/12.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "CIFiltersTableViewController.h"
#import "CIFitlerDetailViewController.h"
#import "OrderedDictionary.h"

@interface CIFiltersTableViewController ()<UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, copy) NSString * selFilterName;
@property (nonatomic, strong) NSMutableArray * allFilters;
@property (nonatomic, strong) NSMutableArray * routineGroup;
@property (nonatomic, strong) OrderedDictionary * filtersGroups;

@property (nonatomic, strong) NSMutableArray * searchResults;

@end

@implementation CIFiltersTableViewController

- (IBAction)cateChanged:(UISegmentedControl *)sender forEvent:(UIEvent *)event
{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self fetchCiFitlersDatasource];
    
    _routineGroup = [[NSMutableArray alloc] initWithObjects:
                   @"CIPhotoEffectMono",
                   @"CIPhotoEffectChrome",
                   @"CIPhotoEffectFade",
                   @"CIPhotoEffectInstant",
                   @"CIPhotoEffectNoir",
                   @"CIPhotoEffectProcess",
                   @"CIPhotoEffectTonal",
                   @"CIPhotoEffectTransfer",
                   @"CISRGBToneCurveToLinear",
                   @"CIVignetteEffect",
                   nil];
    _selFilterName = @"CIPhotoEffectChrome";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchCiFitlersDatasource
{
    if (!_allFilters)  _allFilters = [NSMutableArray array];
    if (!_filtersGroups)  _filtersGroups = [[OrderedDictionary alloc]initWithCapacity:0];
    if (!_searchResults)  _searchResults = [NSMutableArray array];
    
    if (_filtersGroups.count<1 || _allFilters.count<1) {
        NSArray *cats =  @[
                           kCICategoryDistortionEffect,  //扭曲;失真
                           kCICategoryGeometryAdjustment,//几何调整
                           kCICategoryCompositeOperation,//复合操作
                           kCICategoryHalftoneEffect,    //半色调效应
                           kCICategoryColorAdjustment,   //色彩调整
                           kCICategoryColorEffect,       //颜色效果
                           kCICategoryTransition,        //变换
                           kCICategoryTileEffect,        //铺贴效果
                           kCICategoryGenerator,         //发生器
                           kCICategoryReduction,         //衰减 弱变
                           kCICategoryGradient,          //梯度 渐变
                           kCICategoryStylize,           //风格化
                           kCICategorySharpen,           //锐化
                           kCICategoryBlur,              //模糊
                           kCICategoryInterlaced,        //交织
                           kCICategoryNonSquarePixels,   //非方形像素
                           kCICategoryHighDynamicRange,  //HDR(高动态范围)
                           ];
        // ,kCICategoryVideo
        // ,kCICategoryStillImage   //静止图像
        // ,kCICategoryBuiltIn      //内建内建
        // ,kCICategoryFilterGenerator;
        
        for ( NSString *category in cats)
        {
            NSArray<NSString *> * filterNames = [CIFilter filterNamesInCategories:@[category]];
            [_filtersGroups setObject:filterNames forKey:category];
            [_allFilters addObjectsFromArray:filterNames];
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CIFitlerDetailViewController * desVC = segue.destinationViewController;
    desVC.filterName = _selFilterName;
}
 
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (0 == _segmentedControl.selectedSegmentIndex) {
            NSString *category = [self.filtersGroups keyAtIndex:indexPath.section];
            NSArray<NSString *> * filterNames = [self.filtersGroups objectForKey:category];
            _selFilterName = filterNames[indexPath.row];
        }else{
            _selFilterName = self.routineGroup[indexPath.row];
        }
    }else{//UISearchResultsTableView
        _selFilterName = self.searchResults[indexPath.row];
    }
    [self performSegueWithIdentifier:@"CIFilter" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        if (0 == _segmentedControl.selectedSegmentIndex) {
            return self.filtersGroups.count;
        }else{
            return 1;
        }
    }else{
        [self.searchResults removeAllObjects];
        for (NSString * name in self.allFilters) {
            NSRange range = [name rangeOfString:self.searchBar.text];
            if (range.location != NSNotFound) {
                [self.searchResults addObject:name];
            }
        }
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (0 == _segmentedControl.selectedSegmentIndex) {
            NSString *category = [self.filtersGroups keyAtIndex:section];
            NSArray<NSString *> * filterNames = [self.filtersGroups objectForKey:category];
            return filterNames.count;
        }else{
            return _routineGroup.count;
        }
    }else{
        return self.searchResults.count;
    }
    
    return 0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (0 == _segmentedControl.selectedSegmentIndex) {
            NSString *category = [self.filtersGroups keyAtIndex:section];
            return category;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

#define reuseCellID @"CIFilter"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellID forIndexPath:indexPath];
        
        NSString * filterName = @"CIFilter";
        if (0 == _segmentedControl.selectedSegmentIndex) {
            NSString *category = [self.filtersGroups keyAtIndex:indexPath.section];
            NSArray<NSString *> * filterNames = [self.filtersGroups objectForKey:category];
            if (indexPath.row < filterNames.count) {
                filterName = filterNames[indexPath.row];
            }
        }else{
            if (indexPath.row<_routineGroup.count) {
                filterName = self.routineGroup[indexPath.row];
            }
        }
    //filterName = [filterName substringFromIndex:[filterName rangeOfString:@"CIPhotoEffect"].length];
        // Configure the cell...
        cell.textLabel.text = filterName;
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"reuseIdentifier"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
        }
        // Configure the cell...
        cell.textLabel.text = self.searchResults[indexPath.row];
        return cell;
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

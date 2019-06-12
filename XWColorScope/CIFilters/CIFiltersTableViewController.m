//
//  CIFiltersTableViewController.m
//  XWColorScope
//
//  Created by vivi wu on 2019/6/12.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "CIFiltersTableViewController.h"
#import "CIFitlerDetailViewController.h"

@interface CIFiltersTableViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, copy) NSString * selFilterName;
@property (nonatomic, copy) NSArray * cifilters;
@property (nonatomic, strong) NSMutableArray * dataSourse;

@end

@implementation CIFiltersTableViewController

- (IBAction)cateChanged:(UISegmentedControl *)sender forEvent:(UIEvent *)event
{
    if (0 == sender.selectedSegmentIndex) {
        
    }else{
    
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSArray *filterNames = [CIFilter filterNamesInCategory:kCICategoryCompositeOperation];
    XWLog(@"总共有%lu种滤镜效果:%@",(unsigned long)filterNames.count, filterNames);
    _cifilters = filterNames;
    
    _dataSourse = [[NSMutableArray alloc] initWithObjects:
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CIFitlerDetailViewController * desVC = segue.destinationViewController;
    desVC.filterName = _selFilterName;
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{

}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == _segmentedControl.selectedSegmentIndex) {
        if (indexPath.row<_cifilters.count) {
            _selFilterName = self.cifilters[indexPath.row];
        }
    }else{
        if (indexPath.row<_dataSourse.count) {
            _selFilterName = self.dataSourse[indexPath.row];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == _segmentedControl.selectedSegmentIndex) {
        return _cifilters.count;
    }else{
        return _dataSourse.count;
    }
    return 0;
}

#define reuseIdentifier @"CIFilter"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString * filterName = @"CIFilter";
    if (0 == _segmentedControl.selectedSegmentIndex) {
        if (indexPath.row<_cifilters.count) {
            filterName = self.cifilters[indexPath.row];
        }
    }else{
        if (indexPath.row<_dataSourse.count) {
            filterName = self.dataSourse[indexPath.row];
        }
    }
//    filterName = [filterName substringFromIndex:[filterName rangeOfString:@"CIPhotoEffect"].length];
    // Configure the cell...
    cell.textLabel.text = filterName;
    return cell;
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

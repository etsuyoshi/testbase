//
//  BSBankIndexTableViewController.m
//  BASE
//
//  Created by Takkun on 2014/04/12.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSBankIndexTableViewController.h"

#import "BSBank.h"
#import "BSMoneyManager.h"



@interface BSBankIndexTableViewController ()

@end

@implementation BSBankIndexTableViewController{
    
    NSMutableArray *_sectionTitlesArray;
    
    NSArray *_bankArray;
    
    NSString *_bankCode;
    NSString *_bankName;

    
}

- (id)initWithStyle:(UITableViewStyle)style bankCode:(NSString *)bankCode bankName:(NSString *)bankName;
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if (bankCode) {
            NSLog(@"bankCode:%@",bankCode);
            
            _bankCode = bankCode;
            _bankName = bankName;
            
            [[BSSellerAPIClient sharedClient] getAllBankBranchesWithSessionId:[BSUserManager sharedManager].sessionId bankCode:bankCode completion:^(NSDictionary *results, NSError *error) {
                
                NSLog(@"getAllBankBranchesWithSessionId:%@",results);
                NSLog(@"getAllBankBranchesWithSessionId:error:%@,",results[@"error"][@"message"]);
                _bankArray = results[@"result"][@"Branch"];
                _sectionTitlesArray = [NSMutableArray array];
                
                for (int n = 0; n < _bankArray.count; n++) {
                    [_sectionTitlesArray addObject:_bankArray[n][0][@"index"]];
                }
                NSLog(@"_sectionTitlesArray:%@",_sectionTitlesArray);
                
                [self.tableView reloadData];

                
            }];
            
        } else {
            
            [[BSSellerAPIClient sharedClient] getAllBanksWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
                NSLog(@"getAllBanksWithSessionId:%@",results);
                
                _bankArray = results[@"result"][@"Bank"];
                _sectionTitlesArray = [NSMutableArray array];
                
                for (int n = 0; n < _bankArray.count; n++) {
                    [_sectionTitlesArray addObject:_bankArray[n][0][@"index"]];
                }
                NSLog(@"_sectionTitlesArray:%@",_sectionTitlesArray);
                
                [self.tableView reloadData];
                
            }];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
        
    /*
    _sectionTitlesArray = [NSArray arrayWithObjects:
                          @"あ", @"い", @"う", @"え", @"お",
                          @"か", @"き", @"く", @"け", @"こ",
                          @"さ", @"し", @"す", @"せ", @"そ",
                          @"た", @"ち", @"つ", @"て", @"と",
                          @"な", @"に", @"ぬ", @"ね", @"の",
                          @"は", @"ひ", @"ふ", @"へ", @"ほ",
                          @"ま", @"み", @"む", @"め", @"も",
                          @"や", @"ゆ", @"よ",
                          @"ら", @"り", @"る", @"れ", @"ろ",
                          @"わ", @"を", @"ん", nil];
     */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_sectionTitlesArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rows;
    if (_bankArray.count) {
        NSArray *bankArray = _bankArray[section];
        rows = bankArray.count;
    } else {
        rows = 0;
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitlesArray objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (_bankArray.count) {
        
        if (_bankCode) {
            cell.textLabel.text = _bankArray[indexPath.section][indexPath.row][@"branch_name"];

        } else {
            cell.textLabel.text = _bankArray[indexPath.section][indexPath.row][@"bank_name"];

        }
        NSLog(@"section:%d,row:%d",indexPath.section, indexPath.row);
    }
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [NSArray arrayWithObjects:
            @"あ", @"い", @"う", @"え", @"お",
            @"か", @"き", @"く", @"け", @"こ",
            @"さ", @"し", @"す", @"せ", @"そ",
            @"た", @"ち", @"つ", @"て", @"と",
            @"な", @"に", @"ぬ", @"ね", @"の",
            @"は", @"ひ", @"ふ", @"へ", @"ほ",
            @"ま", @"み", @"む", @"め", @"も",
            @"や", @"ゆ", @"よ",
            @"ら", @"り", @"る", @"れ", @"ろ",
            @"わ", @"を", @"ん", nil];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_sectionTitlesArray indexOfObject:title];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if (_bankCode) {
        
        NSString *branchName = _bankArray[indexPath.section][indexPath.row][@"branch_name"];
        NSString *branchCode = _bankArray[indexPath.section][indexPath.row][@"branch_code"];

        BSBank *bank = [[BSBank alloc] initWithBankName:_bankName bankCode:_bankCode branchName:branchName branchCode:branchCode];
        [[BSMoneyManager sharedManager] saveBank:bank withBlock:^(NSError *error) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];

        }];

    } else {
        
        NSString *bankName = _bankArray[indexPath.section][indexPath.row][@"bank_name"];
        NSString *bankCode = _bankArray[indexPath.section][indexPath.row][@"bank_code"];

        BSBankIndexTableViewController *vc = [[BSBankIndexTableViewController alloc] initWithStyle:UITableViewStyleGrouped bankCode:bankCode bankName:bankName];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

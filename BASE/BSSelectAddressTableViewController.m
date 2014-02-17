//
//  BSSelectAddressTableViewController.m
//  BASE
//
//  Created by Takkun on 2014/02/05.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSSelectAddressTableViewController.h"

#import "BSAddressInfoCell.h"
#import "BSInputAddressViewController.h"
#import "UICKeyChainStore.h"
#import "BSSelectPaymentTableViewController.h"



@interface BSSelectAddressTableViewController ()

@end

@implementation BSSelectAddressTableViewController{
    BOOL firstCellOpened;
    BOOL secondCellOpened;
    
    int showCells;

}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"お届け先の選択";
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    
    if (![store dataForKey:@"firstUserAddress"]) {
        NSLog(@"firstUserAddressないよ");
        showCells = 0;
    } else {
        showCells = 1;
        if (![store dataForKey:@"secondUserAddress"]) {
            
        } else {
            showCells = 2;
        }
        
    }
    [self.tableView reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rows;
    
    switch (section) {
        case 0:
            rows = showCells;
            break;
        case 1:
            if (showCells == 2) {
                rows = 0;
            } else {
                rows = 1;
            }
            break;
            
        default:
            rows = 2;
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"addressInfoCell,section:%d,rows:%d",indexPath.section, indexPath.row];
    
    
    if (indexPath.section == 0) {

        BSAddressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            UINib* nib = [UINib nibWithNibName:@"BSAddressInfoCell" bundle:nil];
            NSArray* array = [nib instantiateWithOwner:nil options:nil];
            cell = [array objectAtIndex:0];
            cell.editButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.editButton.layer.borderWidth = 1.0;
            cell.editButton.layer.cornerRadius = 5.0;
            cell.editButton.tag = indexPath.row;
            
            [cell.editButton addTarget:self action:@selector(editButtonHighlight:) forControlEvents:UIControlEventTouchDown];
            [cell.editButton addTarget:self action:@selector(editButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.orderButton.layer.borderColor = [UIColor colorWithRed:25.0/255.0 green:148.0/255.0 blue:250.0/255.0 alpha:1.0].CGColor;
            cell.orderButton.layer.borderWidth = 1.0;
            cell.orderButton.layer.cornerRadius = 5.0;
            cell.orderButton.tag = indexPath.row;
            
            [cell.orderButton addTarget:self action:@selector(orderButtonHighlight:) forControlEvents:UIControlEventTouchDown];
            [cell.orderButton addTarget:self action:@selector(orderButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.deleteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.deleteButton.layer.borderWidth = 1.0;
            cell.deleteButton.layer.cornerRadius = 5.0;
            cell.deleteButton.tag = indexPath.row;
            [cell.deleteButton addTarget:self action:@selector(deleteButtonHighlight:) forControlEvents:UIControlEventTouchDown];
            [cell.deleteButton addTarget:self action:@selector(deleteButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
            
            UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
            NSDictionary *decodeDictionary;
            if (indexPath.row == 0) {

                decodeDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[store dataForKey:@"firstUserAddress"]];
                
                cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",decodeDictionary[@"lastName"], decodeDictionary[@"firstName"]];
                
                cell.zipcodeLabel.text = [NSString stringWithFormat:@"〒%@",decodeDictionary[@"zipcode"]];
                
                cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",decodeDictionary[@"prefecture"] , decodeDictionary[@"address"], decodeDictionary[@"detailAddress"]];
            
                
            } else {
                decodeDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[store dataForKey:@"secondUserAddress"]];
                
                cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",decodeDictionary[@"lastName"], decodeDictionary[@"firstName"]];
                
                cell.zipcodeLabel.text = [NSString stringWithFormat:@"〒%@",decodeDictionary[@"zipcode"]];
                
                cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",decodeDictionary[@"prefecture"] , decodeDictionary[@"address"], decodeDictionary[@"detailAddress"]];
                
            }
        
        }
        return cell;

    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 20)];
            textLabel.text = @"お届け先を新しく作る";
            textLabel.center = CGPointMake(cell.center.x, cell.center.y);
            [cell addSubview:textLabel];
        }
        return cell;

    }

    
    // Configure the cell...
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: // 1個目のセクションの場合
            if (showCells == 0) {
                return nil;
            }
            return @"お届け先を選択";
            break;
    }
    return nil; //ビルド警告回避用
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                if (firstCellOpened) {
                    return 170;
                    
                } else {
                    return 92;
                    
                }
            } else {
                if (secondCellOpened) {
                    return 170;
                    
                } else {
                    return 92;
                    
                }
            }
            break;
        case 1:
            return 44;
            break;
        default:
            break;
    }
    return 92;
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (showCells == 0) {
        if (section == 1) {
            return 0.1;
        }else{
            return 0.1;
        }
    } else {
        return UITableViewAutomaticDimension;
    }
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                firstCellOpened = (firstCellOpened)? NO:YES;
                break;
            case 1:
                secondCellOpened = (secondCellOpened)? NO:YES;
                break;
                
            default:
                break;
        }
        NSLog(@"didSelectRowAtIndexPath");
        NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        
        BSInputAddressViewController *vc = [[BSInputAddressViewController alloc] init:0];
        [self.navigationController pushViewController:vc animated:YES];
    }

    // ハイライト解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)editButtonHighlight:(id)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    BSAddressInfoCell *selectedCell = (BSAddressInfoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [sender setBackgroundColor:[UIColor lightGrayColor]];
    [selectedCell.buttonTitleLabel setTextColor:[UIColor whiteColor]];

    [UIView commitAnimations];

}

- (void)editButtonNormal:(id)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    BSAddressInfoCell *selectedCell = (BSAddressInfoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [sender setBackgroundColor:[UIColor whiteColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedCell.buttonTitleLabel setTextColor:[UIColor lightGrayColor]];

    
    [UIView commitAnimations];
    
    BSInputAddressViewController *vc = [[BSInputAddressViewController alloc] init:[sender tag] + 1];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)orderButtonHighlight:(id)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    BSAddressInfoCell *selectedCell = (BSAddressInfoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [sender setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:148.0/255.0 blue:250.0/255.0 alpha:1.0]];
    [selectedCell.orderButtonTitleLabel setTextColor:[UIColor whiteColor]];
    
    [UIView commitAnimations];
    
}

- (void)orderButtonNormal:(id)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    BSAddressInfoCell *selectedCell = (BSAddressInfoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [sender setBackgroundColor:[UIColor whiteColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedCell.orderButtonTitleLabel setTextColor:[UIColor colorWithRed:25.0/255.0 green:148.0/255.0 blue:250.0/255.0 alpha:1.0]];
    
    
    [UIView commitAnimations];
    
    BSSelectPaymentTableViewController *vc = [[BSSelectPaymentTableViewController alloc] initWithStyle:UITableViewStyleGrouped savedUserNumber:[sender tag] + 1];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)deleteButtonHighlight:(id)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    BSAddressInfoCell *selectedCell = (BSAddressInfoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [sender setBackgroundColor:[UIColor lightGrayColor]];
    [selectedCell.deleteButtonTitleLabel setTextColor:[UIColor whiteColor]];
    
    [UIView commitAnimations];
    
}

- (void)deleteButtonNormal:(id)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    BSAddressInfoCell *selectedCell = (BSAddressInfoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [sender setBackgroundColor:[UIColor whiteColor]];
    [selectedCell.deleteButtonTitleLabel setTextColor:[UIColor lightGrayColor]];
    
    [UIView commitAnimations];
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"" message:@"削除してもよろしいですか？"
                              delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    alert.tag = [sender tag];
    [alert show];
    
}

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];

    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            if (alertView.tag == 0) {
                [store removeItemForKey:@"firstUserAddress"];
                
                if ([store dataForKey:@"secondUserAddress"]) {
                    
                    [store setData:[store dataForKey:@"secondUserAddress"] forKey:@"firstUserAddress"];
                    [store removeItemForKey:@"secondUserAddress"];
                    showCells = 1;
                    secondCellOpened = NO;

                } else {
                    showCells = 0;
                    firstCellOpened = NO;
                    
                }
                
                
            } else {
                [store removeItemForKey:@"secondUserAddress"];
                showCells = 1;
                secondCellOpened = NO;
                
            }
            [store synchronize];
            [self.tableView reloadData];
            break;
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

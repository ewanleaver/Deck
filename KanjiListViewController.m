//
//  MasterViewController.m
//  Deck
//
//  Created by Ewan Leaver on 21/04/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import "KanjiListViewController.h"
#import "Character.h"

@interface KanjiListViewController ()

@end

@implementation KanjiListViewController

bool readingsToggled = false;

@synthesize managedObjectContext;
@synthesize characters;

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
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    self.managedObjectContext = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Character" inManagedObjectContext:managedObjectContext];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"literal == %@",@"酒"];
    [fetchRequest setEntity:entity];
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"jlpt == %@", @"4"]];
    NSError *error;
    self.characters = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.title = @"Kanji";
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [characters count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Character *character = [characters objectAtIndex:indexPath.row];
    cell.textLabel.text = character.literal;
    
    if (!readingsToggled) {
        
        cell.detailTextLabel.textColor = [UIColor colorWithRed:(185.0 / 255.0) green:(185.0 / 255.0) blue:(185.0 / 255.0) alpha: 1];
        
        if (![character.reading_kun isEqualToString:@""]) {
            if (![character.reading_on isEqualToString:@""]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", character.reading_on, character.reading_kun];
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", character.reading_kun];
            }
        } else {
            if (![character.reading_on isEqualToString:@""]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", character.reading_on];
            } else {
                cell.detailTextLabel.text = @"";
            }
        }

    } else {
        
        cell.detailTextLabel.textColor = [UIColor colorWithRed:(220.0 / 255.0) green:(140.0 / 255.0) blue:(140.0 / 255.0) alpha: 1];
        
        if (![character.reading_pin isEqualToString:@""]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", character.reading_pin];
        } else {
            cell.detailTextLabel.text = @"";
        }
        
    }
    
    
    
    
    return cell;
}

- (IBAction)togglePinyin:(id)sender {
    
    readingsToggled = !readingsToggled;
    
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.tableView reloadData];
//    }];
    
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    // Reload table with a slight animation
    [UIView transitionWithView:self.tableView
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.tableView reloadData];
                    } completion:NULL];
    
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

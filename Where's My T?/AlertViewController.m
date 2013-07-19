//
//  AlertViewController.m
//  Where's My T
//
//  Created by George Wu on 1/26/13.
//  Copyright (c) 2013 George Wu. All rights reserved.
//

#import "AlertViewController.h"
#import "DetailViewController.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

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
    
    // get rss feed url
    NSURL *url = [NSURL URLWithString:@"http://talerts.com/rssfeed/alertsrss.aspx"];
    
    // get data from url
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // create parser
    parser = [[NSXMLParser alloc] initWithData:data];
    
    // set parser delegate to self
    [parser setDelegate:self];
    
    // parse data
    [parser parse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    // set data to nothing initially
    value = nil;
    
    // found an alert
    if ([elementName isEqualToString:@"title"])
    {
        // if titles array hasn't been allocated
        if (!titles)
        {
            titles = [[NSMutableArray alloc] init];
        }
    }
    
    // description to go along with alert
    if ([elementName isEqualToString:@"description"])
    {
        // if descriptions array hasn't been allocated
        if (!descriptions)
        {
            descriptions = [[NSMutableArray alloc] init];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // if string hasn't been allocated yet
    if(!value)
        value = [[NSMutableString alloc] initWithString:string];
    
    // attach string to value
    else
        [value appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    // if element is title, add to array
    if([elementName isEqualToString:@"title"])
    {
        if (![value isEqualToString:@"T-Alerts"])
        {
            [titles addObject:value];
            return;
        }
        else
            return;
    }
    
    // if element is description, add to array
    else if ([elementName isEqualToString:@"description"])
    {
        if (![value isEqualToString:@"Recent MBTA T-Alerts"])
        {
            [descriptions addObject:value];
            return;
        }
    }
    return;
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
    return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        // configure cell to have line breaks
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        
        // change cell font to avenir
        cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:15.0];
    }
    // Configure the cell
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [titles objectAtIndex:[indexPath row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get string for cell
    NSString *stringForThisCell = [titles objectAtIndex:[indexPath row]];
    
    // make new font
    UIFont *cellFont = [UIFont fontWithName:@"Avenir" size:15.0];
    
    // make constraint size
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    
    // make new size
    CGSize labelSize = [stringForThisCell sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    // return height
    return labelSize.height + 20;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue"])
    {
        // make dictionary using titles as keys and descriptions as objects
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:descriptions forKeys:titles];
        
        // to other controller
        DetailViewController *controller = (DetailViewController *)segue.destinationViewController;
        
        // set properties
        controller.titleWithDescription = dictionary;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        controller.title = [self.tableView cellForRowAtIndexPath:path].textLabel.text;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segue" sender:self];
    // Navigation logic may go here. Create and push another view controller.
    /*
      *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

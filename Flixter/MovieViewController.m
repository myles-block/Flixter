//
//  MovieViewController.m
//  Flixter
//
//  Created by Myles Block on 6/16/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageview+AFNetworking.h"
#import "InfoPageViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Start the activity indicator
    [self.ActivityIndicator startAnimating];//Created Activity Indicator

    self.TableView.dataSource = self;
    self.TableView.delegate = self;
    
    [self fetchMovies];//Calls the fetch movies function intially
    
    self.refreshControl = [[UIRefreshControl alloc] init];//connects refreshcontrol to self
    [self.refreshControl addTarget:self action: @selector(fetchMovies) forControlEvents:UIControlEventValueChanged];//when beginning of refresh control is triggered it reruns fetchMovies
    self.TableView.refreshControl = self.refreshControl;//end of refreshControl
    
    
    
    // Stop the activity indicator
    // Hides automatically if "Hides When Stopped" is enabled
    
    

    // Do any additional setup after loading the view.
}

- (void)fetchMovies {
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=66fe3a93e9f4d8ebf87b88234f2739df"];
    //API Key changed to v3
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"No Internet Connection" message:@"No stable internet connection found to pull your feed. Please refresh and try again." preferredStyle:UIAlertControllerStyleAlert];
               
               UIAlertAction *buttonOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                   [self actionOk];
               }];
                  
               [controller addAction:buttonOk];
               [self presentViewController:controller animated:YES completion:nil];
           }
           else {
               [self.ActivityIndicator stopAnimating];//doesn't work
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
//               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               // TODO: Get the array of movies
               self.movies = dataDictionary[@"results"];
               for (NSDictionary *movies in self.movies)
               {
                   NSLog(@"%@", movies[@"title"]);
               }
//               NSLog(@"%@", dataDictionary);
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               [self.TableView reloadData];
               [self.refreshControl endRefreshing];
           }
       }];
    [task resume];//runs block of code at the end of it's rsepective cue
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.h
    NSIndexPath *index = self.TableView.indexPathForSelectedRow;
    
    NSDictionary *dataToPass = self.movies[index.row];
    InfoPageViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    //accessing
    cell.MovieTitle.text = movie[@"title"];
    cell.MovieDescription.text = movie[@"overview"];
    
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *completePosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:completePosterURLString];
    [cell.MovieImage setImageWithURL:posterURL];
    
    
    
    return cell;
}


@end

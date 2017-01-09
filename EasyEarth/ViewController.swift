//
//  ViewController.swift
//  EasyEarth
//
//  Created by WGonzalez on 10/24/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
//
//
//1. My app gathers information from an API gathering information about countries
//2. I went on a website, REST countries which gives people public info about countries
//3. Im using data from countries, all gathered and put together by REST Countries
//4. I put roughly about 13 hours


import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate
{
    
    @IBOutlet weak var myTableView: UITableView!
    
    //Creates searchbar on top of tableview
    let searchController = UISearchController(searchResultsController: nil)
    
    //Keeps info to display countries and capital onto tableview
    var displayContries = [[String : String]]()
    //Filters the array above, uses the exact letters in the search and tableview displays "filtered countries" after the search, but fails to segue to proper view controller, instead goes to search display controller
    var filteredCountries = [[String : String]]()
    
    //Stores info about country, capital and population
    var displaycountry = [String]()
    var displayCapital = [String]()
    var displayPopulation = [String]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let urlString = "https://restcountries.eu/rest/v1/all"
        //If statement to see if URL is valid
        if let url = NSURL(string : urlString)
        {
            //Retuns data object from URL. Try checks for URL connection
            if let myData = try? NSData(contentsOfURL: url, options: [])
            {
                //If data object was creatd we createad a json object from library
                let json = JSON(data: myData)
                print("Ok to parse")
                parse(json)
            }
        }
    }
    
    func parse(json : JSON)
    {
        for result in json[].arrayValue
        {
          //Graphs values with keys
            let countryName = result["name"].stringValue
            let capital = result["capital"].stringValue
            let population = result["population"].stringValue
            
            
           //Creates dictionary with keys
            let countryInfo = ["name": countryName, "capital" : capital]
            //Will be shown into the table view
            displayContries.append(countryInfo)
            
            displaycountry.append(countryName)
            //Format will be shown on the ShowInfoController
            displayCapital.append("Capital: " + capital)
            displayPopulation.append("Population: " + population)

        }
        myTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = myTableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        //Table view gets the information from the country info containing displaycountries if nothing is searched or if something is searched it would display the results instead of the whole list
        var countryInfo : [String : String]
        
        if tableView == self.searchDisplayController!.searchResultsTableView
        {
            countryInfo = filteredCountries[indexPath.row]
        }
        else
        {
            countryInfo = displayContries[indexPath.row]
        }
    
        //Cell plugs info from array at key values
        cell.textLabel?.text = "esrdfghjkl;'"
//        cell.textLabel?.text = countryInfo["name"]
        cell.detailTextLabel?.text = "Capital : " +  countryInfo["capital"]!

        return cell
    }

    //Used to change the tableview number of rows depending on the array
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.searchDisplayController!.searchResultsTableView
        {
            return self.filteredCountries.count
        }
        else
        {
            return self.displayContries.count
        }
        
    }
    
    //Filters the result, the text must equal to a country, if so it will grab the information from the displaycountries array and grab that specific value
    func filterContentForSearchText(searchText: String)
    {
        let searchResults = NSPredicate(format: "SELF CONTAINS[c] %@", searchText)
        
        let array = (self.displayContries as NSArray).filteredArrayUsingPredicate(searchResults)
        self.filteredCountries = array as! [[String : String]]
        self.myTableView.reloadData()
    }

    //Runs the function and reloads in the search display controller
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool
    {
        self.filterContentForSearchText(searchString!)
        return true
    }

    //Gets text and applies it to scope
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool
    {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //Segues information over the Show Info Controller
        if let indexPath = myTableView.indexPathForSelectedRow
        {
            let country = displaycountry[(indexPath as NSIndexPath).row]
            let capitalName = displayCapital[(indexPath as NSIndexPath).row]
            let populationInfo = displayPopulation[(indexPath as NSIndexPath).row]
            
            let nextController = segue.destinationViewController as! ShowInfoController
            
            nextController.capitalText = capitalName
            nextController.populationText = populationInfo
            nextController.locationForPreview = country
        }
    }

}

import UIKit

/*
 MY GOALS
 1) Fetch all categories
 https://api.publicapis.org/categories
 
 
 2) Fetch all entries for a specific category
 https://api.publicapis.org/entries?category=animals
 
 */


//MARK: Model

struct TopLevelCategories: Decodable {
    let count: Int
    let entries: [Entry]
}

struct TopLevelObject: Decodable {
    let count: Int
    let categories: [String]
}

struct Entry: Decodable {
    let API: String
    let Description: String
    let Auth: String
    let HTTPS: Bool
    let Cors: String
    let Link: URL
    let Category: String
}

//MARK: Model Controller

class EntryController {
    
    static let baseURL = URL(string: "https://api.publicapis.org/")
    static let entriesEndPoint = "entries"
    static let categoriesEndPoint = "categories"
    static let categoryQueryItemName = "category"
    
//    static func fetchAllCategories(completion: @escaping ([String]) -> Void) {
//        // 1 - URL
//        guard let baseURL = baseURL else { return completion([]) } //https://api.publicapis.org/
//        let categoriesURL = baseURL.appendingPathComponent(categoriesEndPoint) //https://api.publicapis.org/categories
//        print(categoriesURL)
//
//        // 2 - Data Task
//        URLSession.shared.dataTask(with: categoriesURL) { (data, _, error) in
//            // 3 - Error Handling
//            if let error = error {
//                print(error, error.localizedDescription)
//                return completion([])
//            }
//
//            // 4 - Check for Data
//            guard let data = data else { return completion ([]) }
//            print(data)
//
//            // 5 - Decode Data
//            do {
//                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
//                return completion(topLevelObject.categories)
//            } catch {
//                print(error, error.localizedDescription)
//                return completion([])
//            }
//
//        }.resume()
//
//
//    }
    
    static func fetchAllEntriesForCategory(for category: String, completion: @escaping ([Entry]) -> Void) {
        // 1 - URL
        guard let baseURL = baseURL else { return completion([]) }
        let entriesURL = baseURL.appendingPathComponent(entriesEndPoint)
        
        var urlComponents = URLComponents(url: entriesURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: categoryQueryItemName, value: category)]
        
        guard let finalURL = urlComponents?.url else { return completion([]) }
        print(finalURL)
        
        // 2 - Data Task
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            // 3 - Error Handling
            if let error = error {
                print(error, error.localizedDescription)
                return completion([])
            }
            
            // 4 - Check for Data
            print("Check for Data")
            guard let data = data else { return completion([]) }
            print(data)
            
            // 5 - Decode Data
            do {
                let topLevelCategories = try JSONDecoder().decode(TopLevelCategories.self, from: data)
                let entries = topLevelCategories.entries
                return completion(entries)
                
            } catch {
                print(error, error.localizedDescription)
                return completion([])
            }
        }.resume()
        
        
    }
}

//MARK: View Controller

//EntryController.fetchAllCategories { (categories) in
//    for category in categories {
//        print(category)
//    }
//}


EntryController.fetchAllEntriesForCategory(for: "Animals") { (entries) in
    for entry in entries {
        print("""
---------------------
Name: \(entry.API)
Desc: \(entry.Description)
Category: \(entry.Category)
""")
    }
}

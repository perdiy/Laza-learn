////
////  Api.swift
////  Laza
////
////  Created by Perdi Yansyah on 01/08/23.
////
//
//import Foundation
//
//import UIKit
//
//class ViewModel {
//  var welcome = Welcome()
//  var welcomeElement = WelcomeProduct()
//  var reloadCategory: (() -> Void)?
//  var reloadProduct: (() -> Void)?
//
//  // MARK: Get Categories Data from API
//  func getCategories() async throws -> Welcome {
//    let component = URLComponents(string: "https://fakestoreapi.com/products/categories")!
//    let request = URLRequest(url:component.url!)
//    let (data, responses) = try await URLSession.shared.data(for: request)
//    guard (responses as? HTTPURLResponse)?.statusCode == 200 else {
//      fatalError("Error Can't Fetching Data")
//    }
//    let decoder = JSONDecoder()
//    let result = try decoder.decode(Welcome.self, from: data)
//    return result
//  }
//
//  // MARK: Get Product Data from API
//  func getProduct() async throws -> WelcomeProduct {
//    let component = URLComponents(string: "https://fakestoreapi.com/products")!
//    let request = URLRequest(url:component.url!)
//    let (data, responses) = try await URLSession.shared.data(for: request)
//    guard (responses as? HTTPURLResponse)?.statusCode == 200 else {
//      fatalError("Error Can't Fetching Data")
//    }
//    let decoder = JSONDecoder()
//    let result = try decoder.decode(WelcomeProduct.self, from: data)
//    return result
//  }
//
//
//  // MARK: Load All Data that Get From API
//  func loadData(){
//    Task {
//      await getCategoriesData()
//      await getProductData()
//    }
//  }
//
//  // MARK: Get Categories Data from API Async -> XCode say Must Set Async
//  func getCategoriesData() async {
//    do {
//      welcome = try await getCategories()
//      //      print(welcome)
//      reloadCategory?() // Closure For Reload Table
//    } catch {
//      print("Error")
//    }
//  }
//
//  // MARK: Get Product Data from API Async -> XCode say Must Set Async
//  func getProductData() async {
//    do {
//      welcomeElement = try await getProduct()
//      reloadProduct?() // Closure For Reload Table
//    } catch {
//      print("Error")
//    }
//  }
//
//
//
//}

# Transactions

## Overview  
EntainHomeTask is a simple project to present my iOS developing skill and architecture ability in 2023.   
It requests race summary list from an URL and displays raceSummary in a time ordered list of races ordered by advertised start ascending.
It also allows user to turn on/off the switch to fiter different category of racing.
Any race which is one minutes past will be removed and The whole list of racing will be automatically refreshed.


## Orientation
I haven't introduce Cocoapods or Carthage into this project. 

## Devleoping Environment
*Xcode 14.3.1*  
*Swift 5*  
*macOS Ventura Version 13.4*  

### Architeture

SwiftUI + MVVM + Combine

### Unit Test  

Use XCTest framework to testing HomeViewModel, APIClient.

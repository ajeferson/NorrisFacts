# Introduction
NorrisFacts is an iOS application that integrates the [Chuck Norris API](https://api.chucknorris.io) to allow user to list, search and share the most fun jokes about Chuck. It is written in Swift.

# Third-party libraries
- [Moya](https://github.com/Moya/Moya) - network abstraction layer that provides a great way for dealing, organizing and structuring a network abstraction layer. It uses [Alamofire](https://github.com/Alamofire/Alamofire) under the hood.
- [RxSwift](https://github.com/ReactiveX/RxSwift) - reactive programming library for Swift.
- [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa) - reactive extensions for Cocoa APIs.
- [Realm](https://github.com/realm/realm-cocoa) - ultra fast mobile database.
- [Quick](https://github.com/Quick/Quick) - testing framework that allows writing more expressive behavior oriented tests. Rspec-flavored.
- [Nimble](https://github.com/Quick/Nimble) - testing matcher framework.
- [RxBlocking](https://github.com/ReactiveX/RxSwift/tree/master/RxBlocking) - makes testing of RxSwift code easier by turning asynchronous streams into synchronous.
- [RxTest](https://github.com/ReactiveX/RxSwift/tree/master/RxTest) - RxSwift auxiliary testing library that makes reactive testing easier by virtualizing time.
- [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) - tool for stubing network requests that helps in integration testing.

# Installation
The project was built using Xcode 13.5 and iOS 13.5.

I used Carthage as dependency manager and all `.frameworks` are in the repo (reasons why below), so you won't need to run any additional Carthage command. If for any reason you need to reinstall dependencies (e.g. bump versions), you can use the `install-dependencies` script located in the root directory. The script basically runs Carthage bootstrap and removes unnecessary framework added by Carthage (it fetches all submodules for every dependency).

You will also need to install [SwiftLint](https://github.com/realm/SwiftLint). The easiest way is by using Homebrew:
```
brew install swiftlint
```

# CI/CD integration
I used [Bitrise](https://www.bitrise.io) as the CI/CD service. Bitrise is configured to run the following jobs:
- a `primary` testing job thar runs on every Pull Request targetting `develop` branch and prevents merging code in case tests fail.
- a `deploy` job that runs on every commit on `develop`. It runs all automated tests and produces a simulator build.

To grab the latest build, go the commits page of this repo and click on the check right next to newest commit (hopefully it is a ✅). There you can find links that redirects to Bitrise's builds page.

In that page you will find the build log and a `APPS & ARTIFACTS` tab, where you will encounter the build to download. Unzip the downloaded the file to get a simulator build on the `vagrant/deploy` directory. Just drag and drop it into your iOS simulator. TestFlight integration is pending.

Bitrise's build page is restricted to authorized users, so you need to send me your Bitrise email account so I can provide you with the access.

# Project management
Here is the [Trello Board](https://trello.com/b/XmkNtJzX/norrisfacts) used for project management. Every piece of work is documented there and tickets are linked in the Pull Requests.

# Q&A
## Why using RxSwift over Combine and UIKit over SwiftUI?
Even though the project was built with Xcode 11.5 and iOS 13.5, SwiftUI and Combine are fairly new technologies that are still in their early steps, so most of mid big-sized older projects didn't migrate to it yet. Therefore, I wanted to showcase my skills in the technologies that are currently used in the vast majority of projects.

## Why using Bitrise?
Bitrise offers a very easy and quick way to integrate CI/CD. For small and fast projects like this, Bitrise sounded like a perfect fit for me. Only downside is the limited build time for free accounts.

## Why leaving built Carthage frameworks in the codebase?
Basically because of Bitrise's limited build time for free accounts 😂 Since there are a few 3rd-party frameworks being used, build time would exceed the permit.

## Why using Moya as opposed to native Cocoa APIs?
Because of the short and quick nature of this project. I wanted to invest more time in other tasks other than designing a network abstraction layer.

## Why using Realm as opposed to CoreData?
Realm offers a really simple way of working with persistent storage. I particularly don't like the scratch pad way with which CoreData works. Thus, cleaner API. Last but not least, Realm claims to be increadibly fast ⚡️.

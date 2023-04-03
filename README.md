# Notesy

## Project Documentation

[https://docs.google.com/document/d/1Mc2Mn_Zq53q4pyTc13JNVN9FM7m0ZgavzmfYKPhuDkk](https://docs.google.com/document/d/1Mc2Mn_Zq53q4pyTc13JNVN9FM7m0ZgavzmfYKPhuDkk)

A Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Develop and build

To run and/or build the project Flutter package should be installed globally

```
$ flutter pub get 
$ flutter build [platform] --dart-define=c=[environment]
$ flutter run [platform] --dart-define=c=[environment]
```

where `[environment]` is either 'dev' or 'prod'

## Android

The file `/local.properties` should include the line:
```
flutter.minSdkVersion=21
```

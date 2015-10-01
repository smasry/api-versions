## 1.4.2

* Adds support for internal header `api.version`

## 1.4.1

* Adds `ApiVersions::Versions` to track and query all known versions.

## 1.4.0

* Add support for minor versions, including minor_bump generator.

## 1.2.0

* Pass `#api` options to Rails namespace          [#1, David Celis]
* Fix issue with middleware and nil accept header [#2, rposborne]

## 1.1.0

* Use middleware to simplify the MIME type instead of doing it at the controller.

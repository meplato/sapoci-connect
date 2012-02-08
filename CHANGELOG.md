*2012-02-08 (0.1.8)*

* Hardened sapoci-search and put up a banner in optparse
* Updated sapoci gem to 0.1.7: Accept (and replace) comma by dot in
  numeric fields
* Timeout by Faraday is special: `Faraday::Error::TimeoutError`
  instead of `Timeout::Error`

*2011-10-15 (0.1.7)*

* Accept GET and POST on ./bin/sapoci-search

*2011-09-22 (0.1.6)*

* Fixed parsing issues with longtext field on HTML (from SAPOCI gem)

*2011-09-07 (0.1.5)*

* Raise RedirectWithoutLocation error when returning
  HTTP status 302 without setting the HTTP Location header

*2011-09-06 (0.1.4)*

* Make POSTs really post as encoded name/value pairs in the body

*2011-09-06 (0.1.3)*

* Changed middleware for background search to put
  `SAPOCI::Document` into `response.env[:sapoci]` 
  instead of `response.env[:body]`.

*2011-09-06 (0.1.2)*

* Changed semantics of search to always add HTTP method, 
  i.e. `:get` or `:post`
* Added test for timeout errors
* Added test for relative redirects (i.e. redirects without hostname)


*2011-08-30 (0.1.1)*

* Simplify API by separating connection initialization (Faraday) and OCI
  handling via Faraday middleware.
* Added `bin/sapoci-search` script to perform, you name it, SAP OCI
  background search.

*2011-08-29 (0.1.0)*

* Initial version, supporting OCI background search only.

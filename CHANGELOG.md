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

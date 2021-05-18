# SAP OCI Connect

We use this library to work with eprocurement punchout systems that
comply to the SAP OCI 4.0 and 5.0 specification.

## Features

### SAP OCI Background Search

It's as simple as this:

```ruby
conn = Faraday.new("http://onlineshop.com/path")
resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
puts resp.status           # => 200
puts resp.body             # => <SAPOCI::Document>
puts resp.env[:raw_body]   # => "<html>...</html>"
```

You can configure the Faraday connection in all detail. Just be sure to
include the SAPOCI middleware. Here's an example:

```ruby
conn = Faraday.new("http://onlineshop.com/path", params: {"token" => "123"}) do |builder|
  builder.use SAPOCI::Connect::Middleware::FollowRedirects, {cookies: :all, limit: 5}
  builder.use SAPOCI::Connect::Middleware::BackgroundSearch, {preserve_raw: true}
  builder.adapter :net_http
end
```

Or, use symbols:

```ruby
conn = Faraday.new("http://onlineshop.com/path", params: {"token" => "123"}) do |builder|
  builder.use :oci_follow_redirects, {cookies: :all, limit: 5}
  builder.use :oci_background_search, {preserve_raw: true}
  builder.adapter :net_http
end
```

The `SAPOCI::Connect::Middleware::FollowRedirects` expands on the existing
`FaradayMiddleware::FollowRedirects` middleware in that it forwards cookies
and returns some errors like e.g. when a redirect is blank or
the maximum number of redirects is reached.

The `SAPOCI::Connect::Middleware::BackgroundSearch` automatically parses the
response body (just like the JSON and XML parser middlewares do), and returns
an `SAPOCI::Document` to look into. Notice that `{preserve_raw: true}` needs
to be passed as well if you want the original HTTP response body in
`response.env[:raw_body]`.

Review [Faraday](https://github.com/lostisland/faraday) for details on
connection initiation. We require Faraday version 1.0.1 or later.

## Testing

Here's how to test locally:

```sh
bundle install
# Start a second console
rake start_test_server
# Back in first console
bundle exec rake test
```

To test remote OCI punchout shops, use the `REMOTE` environment variable:

```sh
REMOTE="http://remote-site.com/Login.aspx?u=demo&p=secret" rake
```

## Credits

Standing on the shoulder of giants, where giants include:

* Rick Olson and all contributors for
  [faraday](https://github.com/lostisland/faraday),
* Erik Michaels-Ober, Wynn Netherland, et al. for
  [faraday_middleware](https://github.com/lostisland/faraday_middleware)

... and many other contributors. Thanks, guys. You rock!

## License

MIT. See [LICENSE](https://github.com/meplato/sapoci-connect/blob/master/LICENSE).

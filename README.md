# SAP OCI Connect

We use this library to work with eprocurement punchout systems that
comply to the SAP OCI 4.0 specification.

## Features

### SAP OCI Background Search

It's as simple as this:

    conn = Faraday.new("http://onlineshop.com/path", :params => {"token" => "123"}) do |builder| 
      builder.response :follow_redirects, :cookies => :all, :limit => 5
      builder.response :background_search
      builder.adapter  :net_http
    end

    conn.options[:timeout] = 5
    conn.options[:open_timeout] = 10

    resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
    puts resp.status # => 200
    puts resp.body   # => <SAPOCI::Document>
    puts resp.env[:raw_body]   # => "<html>...</html>"

Review [Faraday](https://github.com/technoweenie/faraday) for details on 
connection initiation. We require Faraday version 0.8.0 or later.

## Testing

Here's how to test locally:

    $ bundle update
    $ # Start a second console
    $ ruby test/live_server.rb
    $ # Back in first console
    $ rake

To test external servers, use the REMOTE environment variable:

    $ REMOTE="http://remote-site.com/Login.aspx?u=demo&p=secret" rake

## Credits

Standing on the shoulder of giants, where giants include:

* Rick Olson for [faraday](https://github.com/technoweenie/faraday),
* Erik Michaels-Ober, Wynn Netherland, et al. for
  [faraday_middleware](https://github.com/pengwynn/faraday_middleware),
* Ilya Grigorik for [em-synchrony](https://github.com/igrigorik/em-synchrony),
  [em-http-request](https://github.com/igrigorik/em-http-request) and stuff,
* David Balatero and Paul Dix for [typhoeus](https://github.com/dbalatero/typhoeus)

... and many other contributors. Thanks, guys. You rock!


# SAPOCI Connect

We use this library to work with eprocurement punchout systems that
comply to the SAP OCI 4.0 specification.

## Features

### SAP OCI Background Search

It's as simple as this:

    conn = Faraday.new("http://onlineshop.com/path", :params => {"token" => "123"}) do |builder| 
      builder.use SAPOCI::Connect::Middleware::FollowRedirects
      builder.use SAPOCI::Connect::Middleware::PassCookies
      builder.use SAPOCI::Connect::Middleware::BackgroundSearch
      builder.adapter adapter
    end
    resp = SAPOCI::Connect.search(conn, "toner", "http://return.to/me")
    puts resp.status # => 200
    puts resp.body   # => <SAPOCI::Document>

## Testing

Here's how to test locally:

    $ bundle update
    $ # Start a second console
    $ ruby test/live_server.rb
    $ # Back in first console
    $ rake

To test external servers, use the REMOTE environment variable:

    $ REMOTE="http://remote-site.com/Login.aspx?u=demo&p=secret" rake



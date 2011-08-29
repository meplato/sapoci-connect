# SAPOCI Connect

We use this library to work with eprocurement punchout systems that
comply to the SAP OCI 4.0 specification.

## Testing

Here's how to test locally:

    $ bundle update
    $ # Start a second console
    $ ruby test/live_server.rb
    $ # Back in first console
    $ rake

To test external servers, use the REMOTE environment variable:

    $ REMOTE="http://remote-site.com/Login.aspx?u=demo&p=secret" rake



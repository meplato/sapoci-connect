require 'sinatra'
#set :logging, false

VALID_SEARCH_RESPONSE = <<HTML
<html>
  <head><title>Search1</title></head>
  <body>
    <form method="POST" action="http://return.to/me">
      <input type="hidden" name="NEW_ITEM-DESCRIPTION[1]" value="Apple MacBook Air 11&quot;">
      <input type="hidden" name="NEW_ITEM-QUANTITY[1]" value="1.00">
      <input type="hidden" name="NEW_ITEM-UNIT[1]" value="PCE">
      <input type="hidden" name="NEW_ITEM-PRICE[1]" value="999.90">
      <input type="hidden" name="NEW_ITEM-CURRENCY[1]" value="EUR">
      <input type="hidden" name="NEW_ITEM-PRICEUNIT[1]" value="1">
      <input type="hidden" name="NEW_ITEM-LEADTIME[1]" value="7">
      <input type="hidden" name="NEW_ITEM-VENDOR[1]" value="Apple">
      <input type="hidden" name="NEW_ITEM-VENDORMAT[1]" value="MBA11">
      <input type="hidden" name="NEW_ITEM-MATGROUP[1]" value="NOTEBOOK">
      <input type="hidden" name="NEW_ITEM-LONGTEXT_1:132[]" value="Ein tolles Notebook von Apple.">

      <input type="hidden" name="NEW_ITEM-DESCRIPTION[2]" value="Apple iMac 27&quot;">
      <input type="hidden" name="NEW_ITEM-QUANTITY[2]" value="2.00">
      <input type="hidden" name="NEW_ITEM-UNIT[2]" value="PCE">
      <input type="hidden" name="NEW_ITEM-PRICE[2]" value="1799.00">
      <input type="hidden" name="NEW_ITEM-CURRENCY[2]" value="EUR">
      <input type="hidden" name="NEW_ITEM-PRICEUNIT[2]" value="1">
      <input type="hidden" name="NEW_ITEM-LEADTIME[2]" value="7">
      <input type="hidden" name="NEW_ITEM-VENDOR[2]" value="Apple">
      <input type="hidden" name="NEW_ITEM-VENDORMAT[2]" value="IMAC27">
      <input type="hidden" name="NEW_ITEM-MATGROUP[2]" value="DESKTOP">
      <input type="hidden" name="NEW_ITEM-LONGTEXT_2:132[]" value="Der elegante Desktop-Rechner von Apple.">
    </form>
  </body>
</html>
HTML

def assert_search_params
  halt 500, "FUNCTION parameter is wrong: #{params['FUNCTION']}" unless params['FUNCTION'] == "BACKGROUND_SEARCH"
  halt 500, "SEARCHSTRING parameter is missing" unless params['SEARCHSTRING']
  halt 500, "HOOK_URL parameter is missing" unless params['HOOK_URL']
end

get '/' do
  'hello world'
end

get '/search' do
  content_type :html
  assert_search_params
  VALID_SEARCH_RESPONSE
end

post '/search-with-post' do
  content_type :html
  assert_search_params
  VALID_SEARCH_RESPONSE
end

get '/search-timeout' do
  content_type :html
  assert_search_params
  sleep(10)
  VALID_SEARCH_RESPONSE
end

get '/search/redirect' do
  assert_search_params
  redirect '/search/redirect/target'
end

get '/search/redirect/target' do
  content_type :html
  VALID_SEARCH_RESPONSE
end

get '/search/redirect-with-relative-location' do
  assert_search_params
  status 302
  headers 'Location' => '/search/redirect-with-relative-location/target'
  throw :halt
end

get '/search/redirect-with-relative-location/target' do
  content_type :html
  VALID_SEARCH_RESPONSE
end

get '/search/redirect-and-cookies' do
  response.set_cookie "session_id", :value => "secret"
  assert_search_params
  redirect "/search/redirect-and-cookies/target"
end

get '/search/redirect-and-cookies/target' do
  content_type :html
  if request.cookies['session_id'] == "secret"
    VALID_SEARCH_RESPONSE
  else
    not_found
  end
end

get '/search/redirect-and-cookies-and-domain-and-path' do
  response.set_cookie "session_id", {:value => "secret", :path => "/", :httpOnly => true, :expires => Time.utc(2020,1,1)}
  assert_search_params
  redirect "/search/redirect-and-cookies-and-domain-and-path/target"
end

get '/search/redirect-and-cookies-and-domain-and-path/target' do
  content_type :html
  puts request.cookies
  if request.cookies['session_id'] == "secret"
    VALID_SEARCH_RESPONSE
  else
    not_found
  end
end

# Some shops will redirect but not set the location header
get '/search/redirect-without-location' do
  assert_search_params
  status 302
  throw :halt
end


require 'sinatra'
#set :logging, false

VALID_SEARCH_RESPONSE = <<HTML
<html>
  <head><title>Search1</title></head>
  <body>
    <form method="POST" action="http://return.to/me">
      <input type="hidden" name="NEW_ITEM-DESCRIPTION[1]" value="Apple MacBook Air 11&quot;">
      <input type="hidden" name="NEW_ITEM-QUANTITY[1]" value="1.00">
      <input type="hidden" name="NEW_ITEM-UNIT[1]" value="1">
      <input type="hidden" name="NEW_ITEM-PRICE[1]" value="999.90">
      <input type="hidden" name="NEW_ITEM-CURRENCY[1]" value="EUR">
      <input type="hidden" name="NEW_ITEM-PRICEUNIT[1]" value="1">
      <input type="hidden" name="NEW_ITEM-LEADTIME[1]" value="7">
      <input type="hidden" name="NEW_ITEM-VENDOR[1]" value="Apple">
      <input type="hidden" name="NEW_ITEM-VENDORMAT[1]" value="MBA11">
      <input type="hidden" name="NEW_ITEM-MATGROUP[1]" value="NOTEBOOK">

      <input type="hidden" name="NEW_ITEM-DESCRIPTION[2]" value="Apple iMac 27&quot;">
      <input type="hidden" name="NEW_ITEM-QUANTITY[2]" value="2.00">
      <input type="hidden" name="NEW_ITEM-UNIT[2]" value="1">
      <input type="hidden" name="NEW_ITEM-PRICE[2]" value="1799.00">
      <input type="hidden" name="NEW_ITEM-CURRENCY[2]" value="EUR">
      <input type="hidden" name="NEW_ITEM-PRICEUNIT[2]" value="1">
      <input type="hidden" name="NEW_ITEM-LEADTIME[2]" value="7">
      <input type="hidden" name="NEW_ITEM-VENDOR[2]" value="Apple">
      <input type="hidden" name="NEW_ITEM-VENDORMAT[2]" value="IMAC27">
      <input type="hidden" name="NEW_ITEM-MATGROUP[2]" value="DESKTOP">
    </form>
  </body>
</html>
HTML


get '/' do
  'hello world'
end

get '/search' do
  content_type :html
  VALID_SEARCH_RESPONSE
end

get '/search/redirect' do
  redirect '/search/redirect/target'
end

get '/search/redirect/target' do
  content_type :html
  VALID_SEARCH_RESPONSE
end

get '/search/redirect-and-cookies' do
  response.set_cookie "session_id", "secret"
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


require "erb"

class Hermes < Sinatra::Application
  @@pgconn = PGconn.connect "localhost", 5432, "", "", "hermes_development", "root", ""
  
  configure do
    set :views, "#{File.dirname(__FILE__)}/views"
    set :public, "#{File.dirname(__FILE__)}/public"
  end
  
  before do
    puts '[Params]'
    p params
  end
  
  get '/' do
    erb :index
  end
  
  get '/route' do
    
  end
  
  get '/test_query' do
    res = @@pgconn.exec "SELECT gid, id, length from roads LIMIT 10;"
    res.result.inspect
  end
  
end
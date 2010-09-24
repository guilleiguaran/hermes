require "erb"

class Hermes < Sinatra::Application
  @@pgconn = PGconn.connect "localhost", 5432, "", "", "Hermes", "lacho", "abc123"
  
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
		startId = params['startId']
		goalId = params['goalId']
		if(startId != nil && goalId != nil)
			res = @@pgconn.exec "SELECT vertex_id, cost FROM shortest_path('
		SELECT gid as id, 
			 source::integer, 
			 target::integer, 
			 cost::double precision,
			 reverse_cost::double precision  
			FROM roads', 
		#{startId}, #{goalId}, true, true);"
			indices = res.result
			ruta = Array.new			
			indices.each do |fila|
				id = fila[0]
				res = @@pgconn.exec "SELECT ST_AsText(the_geom) as texto FROM vertices_tmp WHERE id = #{id};"
				ruta << res.result[0][0]
			end		
			ruta.inspect
		else
			"Params missing"
		end		
  end
  
  get '/closest_node' do
		lat = params['Lat'] 
		lon = params['Lon']
		if(lat != nil && lon != nil)
			res = @@pgconn.exec "SELECT id,ST_AsText(the_geom) FROM vertices_tmp ORDER BY ST_Distance(the_geom, GeomFromText('POINT(#{lat} #{lon})', 21892)) LIMIT 1; "
			res.result[0].inspect
		else
			"Params missing"
		end
  end  

  get '/test_query' do
    res = @@pgconn.exec "SELECT gid, id, length from roads LIMIT 10;"
    res.result.inspect
  end
  
end

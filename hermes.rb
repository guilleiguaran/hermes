require "erb"

class Hermes < Sinatra::Application
  AppConfig = YAML.load_file(File.join(Dir.pwd, 'config','app_config.yml'))
  
  @@pgconn = PGconn.connect("localhost", 5432, "", "", 
                            "Hermes", "lacho", "abc123")

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
    start_lat = params['start_lat']
    start_lon = params['start_lon']

    goal_lat = params['end_lat']
    goal_lon = params['end_lon']

    if start_lat && goal_lat && start_lon && goal_lon

      start_id = closest_node(start_lat,start_lon)[0]
      goal_id = closest_node(goal_lat,goal_lon)[0]

			puts start_id

			puts goal_id

      res = @@pgconn.exec("SELECT vertex_id, cost FROM shortest_path('
              SELECT gid as id, 
                     source::integer, 
                     target::integer, 
                     cost::double precision,
                     reverse_cost::double precision  
                     FROM roads', 
                     #{start_id}, #{goal_id}, true, true);")
      
      indices = res.result
      
      ruta = []		
      indices.each do |fila|
        id = fila[0]
        res = @@pgconn.exec "SELECT ST_AsText(the_geom) as texto FROM vertices_tmp WHERE id = #{id};"
	coord = [ res.result[0][0].gsub("POINT(","").gsub(")","").split(" ")[1].to_f,
                  res.result[0][0].gsub("POINT(","").gsub(")","").split(" ")[0].to_f ]
        ruta << coord
      end		
      ruta.to_json
    else
      "Params missing"
    end		
  end
  
  get '/test_route' do
    start_lat = params[:start_lat]
    start_lon = params[:start_lon]
    end_lat = params[:end_lat]
    end_lon = params[:end_lon]
    
    route = [ [start_lat.to_f,start_lon.to_f], [end_lat.to_f, end_lon.to_f] ]
    route.to_json
  end

  def closest_node(lat, lon)
    res = @@pgconn.exec "SELECT id,ST_AsText(the_geom) FROM vertices_tmp ORDER BY ST_Distance(the_geom, GeomFromText('POINT(#{lon} #{lat})', 21892)) LIMIT 1;"
    res.result[0]
  end

end

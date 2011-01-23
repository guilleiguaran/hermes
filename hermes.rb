require "erb"

class Hermes < Sinatra::Application
  AppConfig = YAML.load_file(File.join(Dir.pwd, 'config','app_config.yml'))
  
  @@pgconn = PGconn.connect(AppConfig['db_host'], AppConfig['db_port'], "", "",
                            AppConfig['db_name'], AppConfig['db_user'], AppConfig['db_pass'])

  configure do
    set :views, "#{File.dirname(__FILE__)}/views"
    set :public, "#{File.dirname(__FILE__)}/public"
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
      res = @@pgconn.exec("SELECT ST_AsText(the_geom) FROM shortest_path('SELECT gid as id, source, target, cost, reverse_cost FROM roads',#{start_id}, #{goal_id},true,true) as sp, roads WHERE gid = edge_id;")

      rows = res.result.inspect.gsub("[[","").gsub("]]","").split("], [")
      route = []
      rows.each do |row|
	      multiline = []
        points = row.gsub("MULTILINESTRING((","").gsub("))","").split(",")
	      points.each do |point|
		      coord = [point.split(" ")[1].gsub("\"","").to_f, point.split(" ")[0].gsub("\"","").to_f]
		      multiline << coord	
	      end
	      route << multiline
      end
	    route.to_json
    else
      "Params missing"
    end		
  end
  
  def closest_node(lat, lon)
    res = @@pgconn.exec "SELECT id,ST_AsText(the_geom) FROM vertices_tmp ORDER BY ST_Distance(the_geom, GeomFromText('POINT(#{lon} #{lat})', 21892)) LIMIT 1;"
    res.result[0]
  end

end

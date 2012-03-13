class WebController < ApplicationController
  
  def _stats
    render :json => true, :status => :ok 
  end
  
  def grid_events
    
    page = params['page'].to_i
    limit = params['rows'].to_i
    sidx = params['sidx'];
    sord = params['sord'];
    
    if sord.nil? or sord.empty?
      sord = 'desc'
    end
    
    @@logger.debug "#### #{params.inspect}"
    
    count = Event.all.count
    
    @@logger.debug "#### #{count.inspect} #{limit.inspect}"
    
    total_pages = 0
    
    if count > 0
      @@logger.debug "#### #{count.inspect} #{limit.inspect}"
      total_pages = count/limit;
    end 
    
    @@logger.debug "#### #{total_pages.inspect} #{page.inspect}"

    page = total_pages if page > total_pages
    
    @@logger.debug "#### #{page.inspect}"
    
    start = limit*page - limit
    
    @@logger.debug "#### #{start.inspect}"
    
    sql = "Select e.id,e.title,e.place from events as e order by #{sidx} #{sord} LIMIT #{start} , #{limit}"
    
    @@logger.debug "#### #{sql.inspect}"
    
    @events = Event.find_by_sql(sql)
    
     @@logger.debug "#### #{@events.inspect}"
    
    rows = []
    
    @events.each do |event|
      rows << {"id" => event['id'], "cell" => [event['title'],event['place']]}
    end
    
     @@logger.debug "#### #{rows.inspect}"
    
    resp = {
      "page" => page,
      "total" => total_pages,
      "records" => count,
      "rows" => rows
    }
    
    @@logger.debug "#### #{resp.inspect}"
    
    render :json => resp, :status => :ok
  end
  
end



def crush
    data = @data
    @data = deep_compact(data).compact
  end

def deep_compact( data )
    if data.is_a?(Hash)
      puts " - Hash - #{data}"
      data.compact!
      data.each { |k, v| data[k] = deep_compact(v) }
    elsif data.is_a?(Array)
      #puts " - Array - #{data}"
      data.map! { |v| deep_compact(v) }
      #puts " - Array size- #{data.size}"
      data.size == 1 ? deep_compact(data[0]) : data
    elsif data.is_a?(String)
      puts " - String - #{data}"
      data.strip.empty? ? nil : data
    else
      data
    end
end

pp "------- test1 ------ "
data  = [{},{}]
pp data
pp deep_compact (data)


pp "------- test2 ------ "
@data = {:next_url=> ["https://lirias2repo.kuleuven.be/elements-cache/rest/publications?affected-since=2023-01-14T11%3A41%3A41.650Z&#38;after-id=2850104&#38;per-page=2"]}
pp @data
pp deep_compact (@data)
pp crush()
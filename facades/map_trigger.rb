# event thats triggered when a player reaches a certain location in a map
class MapTrigger
  def initialize(map, location, event)
    @map = map
    @location = location
    @event = event
  end
end

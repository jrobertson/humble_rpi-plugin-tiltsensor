#!/usr/bin/env ruby

# file: humble_rpi-plugin-tiltsensor.rb

require 'chronic_duration'
require 'rpi_pinin'


# Hardware test setup:
# 
# * tilt sensor only connected between a GPIO pin and ground
#
# Trigger an event
#
# * To trigger a tilt action either tap the sensor when it is vertical or 
#   tilted at an angle of 45 degrees or more

class HumbleRPiPluginTiltSensor


  def initialize(settings: {}, variables: {})

    @pins = settings[:pins].map {|x| RPiPinIn.new x}
    @duration = settings[:duration] || '1 minute'
    @notifier = variables[:notifier]
    @device_id = variables[:device_id] || 'pi'
    
  end

  def start()

    count = 0
    
    duration = ChronicDuration.parse(@duration)
    notifier = @notifier
    device_id = @device_id
    
    t0 = Time.now + 1
    t1 = Time.now - duration + 10
    
    puts 'ready to detect tilting'
    
    @pins.each.with_index do |pin, i|
      
      Thread.new do      
        
        pin.watch_high do
          
          # ignore any movements that happened 250 
          #               milliseconds ago since the last movement
          if t0 + 0.25 < Time.now then          
            
            count += 1
            
            elapsed = Time.now - (t1  + duration)
            #puts 'elapsed : ' + elapsed.inspect

            if elapsed > 0 then

              # identify if the movement is consecutive
              msg = if elapsed < duration then              
                s = ChronicDuration.output(duration, :format => :long)
                "%s/tilt/%s: detected %s times within the past %s" \
                                                      % [device_id, i, count, s ]
              else              
                "%s/tilt/%s: detected" % [device_id, i]
              end
              
              notifier.notice msg
              t1 = Time.now
              count = 0
            end
            
            t0 = Time.now
          else
            #puts 'ignoring ...'
          end          
          
        end #/ watch_high        
      end #/ thread             
    end

    
  end
  
  alias on_start start  
  
end
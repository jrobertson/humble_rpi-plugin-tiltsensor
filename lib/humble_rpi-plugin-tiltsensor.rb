#!/usr/bin/env ruby

# file: humble_rpi-plugin-tiltsensor.rb

require 'chronic_duration'
require 'pi_piper'


class HumbleRPiPluginTiltSensor
  include PiPiper

  def initialize(settings: {}, variables: {})

    @pins = settings[:pins]
    @duration = settings[:duration] || '1 minute'
    @notifier = variables[:notifier]
    @device_id = variables[:device_id] || 'pi'
      
    at_exit { @pins.each {|pin| File.write '/sys/class/gpio/unexport', pin } }
    
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

      PiPiper.watch :pin => pin.to_i, :invert => true do |pin|        

        # ignore any movements that happened 250 
        #               milliseconds ago since the last movement
        if t0 + 0.25 < Time.now then          
          
          count += 1
          
          elapsed = Time.now - (t1  + duration)
          #puts 'elapsed : ' + elapsed.inspect

          if elapsed > 0 then

            # identify if the movement is consecutive
            msg = if elapsed < duration then              
              "%s/tilt/%s: detected %s times within the past %s" \
                                              % [device_id, i, count, duration]
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
      end
            
    end
    
    PiPiper.wait
    
  end
  
  alias on_start start  
  
end
